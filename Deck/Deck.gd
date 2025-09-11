class_name Deck	
extends Control

const Card = preload("res://Cards/Card.tscn")
#const CardInfo = preload("res://Cards/CardInfo.gd")

signal noMoreDraw()

@onready var player : PlayerController :
	set(nPlayer):
		player = nPlayer 
@onready var deckCardContainer : MarginContainer
@onready var labelRemainingCard : RichTextLabel

#tmp = [0]
## the next card which is drawn is the lastId
var idDeckStartingCard : Array[int] = [0, 1, 0, 1, 0, 4]

var deck: Array[Card]
var cardPile: Control
var nbCardLeft : int : set = setNbCardLeft

func fillCardInDeck(cardHudRef : CardCombatManager, collection: Dictionary[int, CardInfo]) -> void:
	if collection == null || idDeckStartingCard == null:
		return
	for i in range(0, idDeckStartingCard.size()):
		#setting up info for card
		var infoCard : CardInfo = collection[idDeckStartingCard[i]]
		var nCard = Card.instantiate()
		nCard.init(player, infoCard)
		nCard.resolved.connect(cardHudRef.cardAfterResolve.bind(nCard))
		deck.push_back(nCard)
		cardPile.add_child(nCard)
	nbCardLeft = deck.size()
	
func sendToDeck(nCard : Card) -> void:
	nCard.reparent(cardPile)
	deck.push_back(nCard)
	nbCardLeft += 1

func shuffle():
	deck.shuffle()

func drawCard() -> void:
	if nbCardLeft == 0:
		noMoreDraw.emit()
		return
	var cardDrawn : Card = deck.pop_back()
	cardDrawn.setCardZone(CardInfo.CardEnum.CardZone.Hand)
	nbCardLeft -= 1

func setNbCardLeft(nLeft: int) -> void:
	nbCardLeft = nLeft
	if nbCardLeft == 0:
		deckCardContainer.visible = false
	elif deckCardContainer.visible == false && nbCardLeft > 0:
		deckCardContainer.visible = true
	labelRemainingCard.text = "[center]" + str(nbCardLeft) + "[center]"

func _on_tree_entered():
	cardPile = %CardPile
	deckCardContainer = %DeckCardContainer
	labelRemainingCard = %RemainingCardLabel
