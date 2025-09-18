class_name CardCombatManager
extends CanvasLayer
 
const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var player : PlayerController
##All HUD's parts
@onready var deck : Deck
@onready var hand : Hand
@onready var graveyard : Graveyard

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

func refillDeck() -> void:
	var nbCard : int = graveyard.emptyGraveyard(CardEnum.CardZone.Deck)
	if nbCard == 0:
		##TODO make something in this case
		return
	deck.setNbCardLeft(nbCard)
	deck.shuffle()
	deck.drawCard()

func _ready():
	deck.player = player
	deck.cardAddedToDeck.connect(onCardAddedToDeck)
	deck.noMoreDraw.connect(refillDeck)
	deck.fillCardInDeck()
	hand.player = player
	for i in range(0, hand.handSizeLimit):
		deck.drawCard()
	

func _on_tree_entered():
	deck = %Deck
	hand = %Hand
	graveyard = %Graveyard
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	player = get_parent()
	
func onCardAddedToDeck(nCard: Card):
	nCard.resolved.connect(cardAfterResolve.bind(nCard))
