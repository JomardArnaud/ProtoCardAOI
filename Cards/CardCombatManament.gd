class_name CardCombatManager
extends CanvasLayer

var ClassCardCollection = preload("res://Cards/CardCollection.gd")
var cardCollection : CardCollection

##All HUD's parts
@onready var deckNode := %Deck
@onready var spellHand := %SpellHand

func _ready()-> void:
	cardCollection = ClassCardCollection.new()
	deckNode.setInfoCard(cardCollection.collection)
	spellHand.setStartingHand(deckNode)
