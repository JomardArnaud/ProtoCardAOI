class_name Deck	
extends Control

const Card = preload("res://Cards/Card.tscn")
#const CardInfo = preload("res://Cards/CardInfo.gd")

@onready var player : PlayerController :
	set(nPlayer):
		player = nPlayer 
@onready var deckCardContainer : MarginContainer
@onready var labelRemainingCard : RichTextLabel

#tmp = [0]
## the next card which is drawn is the lastId
var idDeckCard : Array[int] = [0, 0, 0, 0, 0, 0]

var deck: Array[Card]
var nbCardLeft : int : set = setNbCardLeft

func fillCardInDeck(cardHudRef : CardCombatManager, collection: Dictionary[int, CardInfo]) -> void:
	if collection == null || idDeckCard == null:
		return
	for i in range(0, idDeckCard.size()):
		#setting up info for card
		var infoCard : CardInfo = collection[idDeckCard[i]]
		var nCard = Card.instantiate()
		nCard.init(player, infoCard)
		deck.push_back(nCard)
	nbCardLeft = deck.size()

func shuffle():
	idDeckCard.shuffle()
	pass

func refilldeck():
	pass

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

func _on_tree_entered():	
	deckCardContainer = %DeckCardContainer
	labelRemainingCard = %RemainingCardLabel
