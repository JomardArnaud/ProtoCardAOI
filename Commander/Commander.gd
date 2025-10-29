class_name Commander
extends Node2D

const CardEnum = preload("res://Cards/CardEnum.gd")

@export var commanderInfo : CommanderInfo
@export var body : MovementBody2D
@export var cardHud : CardHudContainer

##All HUD's parts
@onready var deck : Deck
@onready var hand : Hand
@onready var graveyard : Graveyard

var getDirDash : Callable
var getDirAttack : Callable

func _ready():
	var parent = get_parent()
	if parent.has_method("getDirDash"):
		getDirDash = parent.getDirDash
	else:
		getDirDash = func() -> Vector2 : return Vector2.ZERO
	if parent.has_method("getDirAttack"):
		getDirAttack = parent.getDirAttack
	else:
		getDirAttack = func() -> Vector2 : return Vector2.ZERO
	deck = cardHud.get_node("%Deck")
	hand = cardHud.get_node("%Hand")
	graveyard = cardHud.get_node("%Graveyard")
	deck.commander = self
	deck.cardAddedToDeck.connect(onCardAddedToDeck)
	deck.noMoreDraw.connect(refillDeck)
	deck.fillCardInDeck()
	for i in range(0, hand.handSizeLimit):
		deck.drawCard()

func _process(delta: float) -> void:
	commanderInfo.currentEnergy += commanderInfo.energyRegen * delta
	
func moveCard(card : Card, to : CardEnum.CardZone) -> void:
	card.hotkeyCard = ""
	match to:
		CardEnum.CardZone.Deck:
			deck.sendToDeck(card)
		CardEnum.CardZone.Graveyard:
			graveyard.sendToGraveyard(card)
		CardEnum.CardZone.Hand:
			hand.addCardToHand(card)

func cardAfterResolve(card : Card):
	moveCard(card, CardEnum.CardZone.Graveyard)
	hand.fillSlotCard()
	deck.drawCard()
	print(commanderInfo.currentEnergy)

func refillDeck() -> void:
	var nbCard : int = graveyard.emptyGraveyard(CardEnum.CardZone.Deck)
	if nbCard == 0:
		##TODO make something in this case
		return
	deck.setNbCardLeft(nbCard)
	deck.shuffle()
	deck.drawCard()

func onCardAddedToDeck(nCard: Card):
	nCard.resolved.connect(cardAfterResolve.bind(nCard))
