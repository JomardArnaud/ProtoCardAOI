class_name Commander
extends Node2D

const CardInfo = preload("res://Cards/CardInfo.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")
const CardNode = preload("res://Cards/Card.tscn")

@export var commanderInfo : CommanderInfo
@export var body : MovementBody2D
@export var cardHud : CardHudContainer

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
	deck.noMoreDraw.connect(refillDeck)

func _process(delta: float) -> void:
	commanderInfo.currentEnergy += commanderInfo.energyRegen * delta

func setupCardEnvironment() -> void:
	while (hand.getNbCardInHand() < commanderInfo.nbCardStartingHand && deck.cardPile.get_child_count() > 0):
		drawCard()

func moveCard(card : Card, to : CardEnum.CardZone) -> void:
	card.hotkeyCard = ""
	match to:
		CardEnum.CardZone.Deck:
			deck.sendToDeck(card)
		CardEnum.CardZone.Graveyard:
			graveyard.sendToGraveyard(card)
		CardEnum.CardZone.Hand:
			hand.sendCardToHand(card)

func createCard(idCard : int, to : CardEnum.CardZone) -> void:
	var infoCard : CardInfo = CardCollection.getCardById(idCard)
	var nCard = CardNode.instantiate()
	nCard.init(self, infoCard)
	nCard.resolved.connect(cardAfterResolve.bind(nCard))
	moveCard(nCard, to)

func fillDeck(startingDeck : Dictionary[int,int]) -> void:
	if startingDeck.is_empty():
		push_warning("No cards in starter deck")
		return
	for keyCard in startingDeck:
		for i in range(0, startingDeck[keyCard]):
			createCard(keyCard, CardEnum.CardZone.Deck)
	deck.shuffle()

func castSlotCard(idSlot : int):
	hand.castSlotCard(idSlot)

func castHandCard(idCard : int):
	hand.castHandCard(idCard)

func cardAfterResolve(card : Card):
	card.setCardZone(CardEnum.CardZone.Graveyard)
	hand.fillSlotCard()
	drawCard()

func refillDeck() -> void:
	var nbCard : int = graveyard.emptyGraveyard(CardEnum.CardZone.Deck)
	if nbCard == 0:
		##TODO make something in this case
		return
	deck.shuffle()
	drawCard()

func drawCard() -> void:
	if hand.getNbCardInHand() < commanderInfo.handSizeLimit && deck.cardPile:
		deck.drawCard()

func setWeapon(nWeapon: Weapon) -> void:
	weapon = nWeapon
