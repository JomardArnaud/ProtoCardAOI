class_name Hand
extends MarginContainer

var CardScene = preload("res://Cards/Card.tscn")
var ClassCardInfo = preload("res://Cards/CardInfo.gd")

@export var handSizeLimit : int = 3

@onready var nbCardHand : int = 0
@onready var cardHandNode := %CardContainer
## hand will always need a deck to work
@onready var deck : Deck

func _ready() -> void:
	pass
	
func drawCard(nbCardDraw : int = 1) -> void:
	for i in range (0, nbCardDraw):
		var lastDrawnCardInfo := deck.drawCard()
		if lastDrawnCardInfo == null:
			return
		#tmp here card will emit the singal cardDrawn
		var lastDrawnCard = CardScene.instantiate()
		lastDrawnCard.setCardInfo(lastDrawnCardInfo)
		if lastDrawnCard == null:
			return
		cardHandNode.add_child(lastDrawnCard)
		
		
func setStartingHand(nDeck: Deck) -> void:
	deck = nDeck
	drawCard(handSizeLimit)	
