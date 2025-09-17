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
var startingDeck : Dictionary[int, int] = {
	0: 2,
	1: 2,
	2: 4,
	3: 4,
	4: 4
}
var deck: Array[Card]
var cardPile: Control
var nbCardLeft : int : set = setNbCardLeft

func addCardById(idCard: int, cardHudRef : CardCombatManager, collection: Dictionary[int, CardInfo]) -> void:
	var infoCard : CardInfo = collection[idCard]
	var nCard = Card.instantiate()
	nCard.init(player, infoCard)
	nCard.resolved.connect(cardHudRef.cardAfterResolve.bind(nCard))
	deck.push_back(nCard)
	cardPile.add_child(nCard)

func fillCardInDeck(cardHudRef : CardCombatManager, collection: Dictionary[int, CardInfo]) -> void:
	if collection == null || startingDeck.is_empty():
		return
	for keyCard in startingDeck:
		#setting up info for card
		for i in range(0, startingDeck[keyCard]):
			addCardById(keyCard, cardHudRef, collection)
	shuffle()
	
func sendToDeck(nCard : Card) -> void:
	nCard.reparent(cardPile)
	deck.push_back(nCard)

func shuffle():
	deck.shuffle()

##TODO t'as un bug quand le deck est vide le sprite ne s'affiche plus 

func drawCard() -> void:
	if nbCardLeft == 0:
		noMoreDraw.emit()
		return
	var cardDrawn : Card = deck.pop_back()
	cardDrawn.setCardZone(CardInfo.CardEnum.CardZone.Hand)

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


func _on_card_pile_child_entered_tree(node: Node) -> void:
	nbCardLeft += 1
	
func _on_card_pile_child_exiting_tree(node: Node) -> void:
	nbCardLeft -= 1
