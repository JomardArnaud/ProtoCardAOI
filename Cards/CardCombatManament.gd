class_name CardCombatManager
extends CanvasLayer

#const CardCollection = preload("res://Cards/CardCollection.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")
var cardCollection : CardCollection

@onready var player : PlayerController
##All HUD's parts
@onready var deckNode : Deck
@onready var hand : Hand
@onready var graveyard : Graveyard

func moveCard(card : Card, to : CardEnum.CardZone) -> void:
	#var mainType = card.cardInfo.type.get_slice(" ", 0)
	match to:
		CardEnum.CardZone.Graveyard:
			graveyard.sendToGraveyard(card)
		CardEnum.CardZone.Hand:
			hand.addCardToHand(card)

func _ready():
	deckNode.player = player
	deckNode.fillCardInDeck(self, cardCollection.collection)
	hand.player = player
	hand.setStartingHand(deckNode)

func _on_tree_entered():
	deckNode = %Deck
	hand = %Hand
	graveyard = %Graveyard
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cardCollection = CardCollection.new()
	player = get_parent()
	
