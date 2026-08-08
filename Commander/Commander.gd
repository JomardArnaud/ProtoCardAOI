class_name Commander
extends Node2D

const CardEnum = preload("res://Cards/CardEnum.gd")

@export var commanderInfo : CommanderInfo
@export var body : MovementBody2D
@export var cardHud : CardHudContainer
#@export var health : Health

##All HUD's parts
@onready var deck : Deck
@onready var hand : Hand
@onready var graveyard : Graveyard
@onready var weapon : Weapon : set = setWeapon

var getDirDash : Callable
var getDirAttack : Callable

## TODO mettre le son "NEVER GIVE UP ! " en son de mort 
 
func _ready():
	deck = cardHud.deck
	hand = cardHud.hand
	graveyard = cardHud.graveyard
	deck.commander = self
	deck.cardAddedToDeck.connect(onCardAddedToDeck)
	deck.noMoreDraw.connect(refillDeck)
	deck.fillCardInDeck()
	while (hand.getNbCardInHand() < commanderInfo.nbCardStartingHand && deck.cardPile.get_child_count() > 0):
		drawCard()

func _process(delta: float) -> void:
	commanderInfo.currentEnergy += commanderInfo.energyRegen * delta
	
func moveCard(card : Card, to : CardEnum.CardZone) -> void:
	card.hotkeyCard = ""
	card.setCardZone(to)
	match to:
		CardEnum.CardZone.Deck:
			deck.sendToDeck(card)
		CardEnum.CardZone.Graveyard:
			graveyard.sendToGraveyard(card)
		CardEnum.CardZone.Hand:
			hand.addCardToHand(card)

func castSlotCard(idSlot : int):
	hand.castSlotCard(idSlot)

func castHandCard(idCard : int):
	hand.castHandCard(idCard)

func cardAfterResolve(card : Card):
	moveCard(card, CardEnum.CardZone.Graveyard)
	hand.fillSlotCard()
	drawCard()
	hand.fillSlotCard()

func refillDeck() -> void:
	var nbCard : int = graveyard.emptyGraveyard(CardEnum.CardZone.Deck)
	if nbCard == 0:
		##TODO make something in this case
		return
	deck.setNbCardLeft(nbCard)
	deck.shuffle()
	deck.call_deferred("drawCard")

func drawCard() -> void:
	if hand.getNbCardInHand() < commanderInfo.handSizeLimit && deck.cardPile:
		deck.drawCard()

func setWeapon(nWeapon: Weapon) -> void:
	weapon = nWeapon

func onCardAddedToDeck(nCard: Card):
	nCard.resolved.connect(cardAfterResolve.bind(nCard))
