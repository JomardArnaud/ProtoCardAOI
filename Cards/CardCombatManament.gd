class_name CardCombatManager
extends CanvasLayer

var ClassCardCollection = preload("res://Cards/CardCollection.gd")
var cardCollection : CardCollection

signal cardCastFromDeck
signal cardCastFromSpellHand(hotkeyCard : String)
signal cardCardFromPermanantHand(hotkeyCard : String)
signal cardCastFromGraveyard
signal cardCastFromExile

@onready var playerRef : PlayerController = %Player

##All HUD's parts
@onready var deckNode := %Deck
@onready var spellHand := %SpellHand

func _ready()-> void:
	cardCollection = ClassCardCollection.new()
	deckNode.fillCardInDeck(self, cardCollection.collection)
	spellHand.setStartingHand(deckNode)

func reactCastCard(zoneCard : CardInfo.CardZone):
	print("cardCastFromSpellHand" == ("cardCardFrom" + str(CardInfo.CardZone.keys()[zoneCard])))
	emit_signal("cardCastFrom" +  str(CardInfo.CardZone.keys()[zoneCard]), "test")
	pass
