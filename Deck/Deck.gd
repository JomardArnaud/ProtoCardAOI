class_name Deck
extends Control

const CardInfo = preload("res://Cards/CardInfo.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")

signal noMoreDraw()

@onready var deckCardContainer : MarginContainer  = %DeckCardContainer
@onready var labelRemainingCard : RichTextLabel = %RemainingCardLabel
@onready var deckCardTexture : TextureRect = %DeckCardTexture

@onready var startingDeck : Dictionary[int, int] = {}
@onready var cardPile: Control = %CardPile
	
func sendToDeck(nCard : Card) -> void:
	if nCard.get_parent() != null:
		nCard.reparent(cardPile)
	else:
		cardPile.add_child(nCard)
	updateUI()

func shuffle():
	var cards := cardPile.get_children()
	cards.shuffle()
	for i in range(cards.size()):
		cardPile.move_child(cards[i], i)

func drawCard() -> Card:
	if cardPile.get_child_count() == 0:
		noMoreDraw.emit()
		return null
	var cardDrawn := cardPile.get_child(cardPile.get_child_count() - 1) as Card
	cardDrawn.setCardZone(CardEnum.CardZone.Hand)
	updateUI()
	return cardDrawn

func updateUI() -> void:
	if labelRemainingCard:
		labelRemainingCard.text = "[center]%s[center]" % str(cardPile.get_child_count())
