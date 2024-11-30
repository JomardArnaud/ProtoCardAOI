class_name Deck	
extends Control

var ClassCard = preload("res://Cards/Card.gd")
var ClassCardInfo = preload("res://Cards/CardInfo.gd")

@onready var deckCardContainer : MarginContainer = %DeckCardContainer
@onready var labelRemainingCard : RichTextLabel = %RemainingCardLabel

#tmp = [0]
## the next card which is drawn is the lastId
var idDeckCard : Array[int] = [0, 0, 0]
var deck: Array[CardInfo]
var nbCardLeft : int : set = setNbCardLeft

func setInfoCard(collection: Array[CardInfo]) -> void:
	if collection == null || idDeckCard == null:
		return
	for i in range(0, idDeckCard.size()):
		deck.push_back(collection[idDeckCard[i]])
	nbCardLeft = deck.size()

func drawCard() -> CardInfo:
	if nbCardLeft == 0:
		return null
	nbCardLeft -= 1
	return deck.pop_back()

func setNbCardLeft(nLeft: int) -> void:
	nbCardLeft = nLeft
	if nbCardLeft == 0:
		deckCardContainer.visible = false
	elif deckCardContainer.visible == false && nbCardLeft > 0:
		deckCardContainer.visible = true
	labelRemainingCard.text = str(nbCardLeft)
