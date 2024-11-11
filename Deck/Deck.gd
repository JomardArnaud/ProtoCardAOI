class_name Deck	
extends Control

var ClassCard = preload("res://Cards/Card.gd")
var ClassCardInfo = preload("res://Cards/CardInfo.gd")

#tmp = [0]
## the next card which is drawn is the lastId
var idDeckCard : Array[int] = [0, 0, 0]
var deck: Array[CardInfo]
var nbCardDeck : int

func setInfoCard(collection: Array[CardInfo]) -> void:
	if collection == null || idDeckCard == null:
		return
	nbCardDeck = idDeckCard.size()
	for i in range(0, nbCardDeck):
		deck.push_back(collection[idDeckCard[i]])

func drawCard() -> CardInfo:
	if nbCardDeck == 0:
		return null
	nbCardDeck -= 1
	return deck.pop_back()
