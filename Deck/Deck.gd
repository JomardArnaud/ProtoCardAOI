class_name Deck	
extends Control

var ClassCard = preload("res://Cards/Card.tscn")
var ClassCardInfo = preload("res://Cards/CardInfo.gd")

@onready var deckCardContainer : MarginContainer = %DeckCardContainer
@onready var labelRemainingCard : RichTextLabel = %RemainingCardLabel

#tmp = [0]
## the next card which is drawn is the lastId
var idDeckCard : Array[int] = [0, 0, 0]


var deck: Array[Card]
var nbCardLeft : int : set = setNbCardLeft


func fillCardInDeck(cardHudRef : CardCombatManager, collection: Array[CardInfo]) -> void:
	if collection == null || idDeckCard == null:
		return
	for i in range(0, idDeckCard.size()):
		var infoCard : CardInfo = collection[idDeckCard[i]]
		print("card is added")
		var tmpCard : Card = ClassCard.instantiate()
		tmpCard.setCardInfo(infoCard)
		tmpCard.cardCast.connect(cardHudRef.reactCastCard)
		deck.push_back(tmpCard)
		
		##tmp here connect signal of the
	nbCardLeft = deck.size()

func drawCard() -> Card:
	if nbCardLeft == 0:
		print("No card left in deck")
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
