class_name CardCombatManager
extends CanvasLayer

#const CardCollection = preload("res://Cards/CardCollection.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")
var cardCollection : CardCollection

@onready var player : PlayerController
##All HUD's parts
@onready var deckNode : Deck
@onready var spellHand : Hand
@onready var graveyard : Graveyard

func moveCard(card : Card, to : CardEnum.CardZone) -> void:
	#var mainType = card.cardInfo.type.get_slice(" ", 0)
	match to:
		CardEnum.CardZone.Graveyard:
			graveyard.sendToGraveyard(card)
		CardEnum.CardZone.SpellHand:
			var strInput : String = "Cast" + CardEnum.CardType.keys()[card.cardInfo.type]
			card.setHotkeyCard(InputManager.get_instance().getHotkeyStr(strInput))
			spellHand.addCardToHand(card)

func _ready():
	deckNode.player = player
	deckNode.fillCardInDeck(self, cardCollection.collection)
	spellHand.player = player
	spellHand.setStartingHand(deckNode)

func _on_tree_entered():
	deckNode = %Deck
	spellHand = %SpellHand
	graveyard = %Graveyard
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cardCollection = CardCollection.new()
	player = get_parent()
	
