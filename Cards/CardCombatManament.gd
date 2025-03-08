class_name CardCombatManager
extends CanvasLayer

#const CardCollection = preload("res://Cards/CardCollection.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")
var cardCollection : CardCollection

@onready var player : PlayerController
@onready var gamepads : GamepadManager
##All HUD's parts
@onready var deckNode : Deck
@onready var spellHand : Hand
@onready var graveyard : Graveyard

#faut que je l'a modifie c'est vraiment du bullshit cette implementation
func moveCard(card : Card, to : CardEnum.CardZone) -> void:
	#var mainType = card.cardInfo.type.get_slice(" ", 0)
	match to:
		CardEnum.CardZone.Graveyard:
			graveyard.sendToGraveyard(card)
		CardEnum.CardZone.SpellHand:
			#setting hotkey's card here
			var sub = card.cardInfo.subType
			var strInput : String = "Cast" + card.cardInfo.subType
			if InputMap.has_action(strInput):
				var débug = InputMap.action_get_events(strInput)[0]
				card.setHotkeyCard(gamepads.get_button_name(0, InputMap.action_get_events(strInput)))
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
	gamepads = GamepadManager.new()
	player = get_parent()
	
