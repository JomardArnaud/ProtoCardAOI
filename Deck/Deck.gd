class_name Deck
extends Control

const CardInfo = preload("res://Cards/CardInfo.gd")

signal noMoreDraw()
signal cardAddedToDeck(nCard : Card)

@onready var deckCardContainer : MarginContainer  = %DeckCardContainer
@onready var labelRemainingCard : RichTextLabel = %RemainingCardLabel
@onready var deckCardTexture : TextureRect = %DeckCardTexture

@onready var startingDeck : Dictionary[int, int] = {}
@onready var deck: Array[Card]
@onready var cardPile: Control = %CardPile
@onready var nbCardLeft : int : set = setNbCardLeft
	
func sendToDeck(nCard : Card) -> void:
	if nCard.get_parent() != null:
		nCard.reparent(cardPile)
	else:
		cardPile.add_child(nCard)
	deck.push_back(nCard)
	setNbCardLeft(nbCardLeft + 1)

func shuffle():
	deck.shuffle()

func drawCard() -> void:
	if nbCardLeft == 0:
		noMoreDraw.emit()
		return
	var cardDrawn : Card = deck.pop_back()
	cardDrawn.setCardZone(CardInfo.CardEnum.CardZone.Hand)
	setNbCardLeft(nbCardLeft - 1)

func setNbCardLeft(nLeft: int) -> void:
	nbCardLeft = nLeft
	labelRemainingCard.text = "[center]" + str(nbCardLeft) + "[center]"
