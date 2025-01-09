class_name CardCombatManager
extends CanvasLayer

var ClassCardCollection = preload("res://Cards/CardCollection.gd")
var cardCollection : CardCollection

@onready var playerRef : PlayerController = %Player

##All HUD's parts
@onready var deckNode : Deck = %Deck
@onready var spellHand : Hand = %SpellHand
@onready var graveyard : Graveyard = %Graveyard

func _ready()-> void:
	cardCollection = ClassCardCollection.new()
	deckNode.fillCardInDeck(self, cardCollection.collection)
	spellHand.setStartingHand(deckNode)

func moveCard(card : Card, to : CardInfo.CardZone) -> void:
	match to:
		CardInfo.CardZone.Graveyard:
			graveyard.sendToGraveyard(card)
		CardInfo.CardZone.SpellHand:
			spellHand.addCardToHand(card)
			
	pass
