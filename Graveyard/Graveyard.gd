class_name Graveyard
extends Control

const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var cardPile : Control
@onready var cardOnTop : Card
@onready var remainingCardLabel : RichTextLabel

func sendToGraveyard(card : Card):
	card.visible = false
	cardOnTop.cardInfo = card.cardInfo
	cardOnTop.updateCardNode()
	cardOnTop.visible = true
	card.reparent(cardPile)
	remainingCardLabel.text = "[center]%s[center]" % str(cardPile.get_child_count())

func emptyGraveyard(destZone: CardEnum.CardZone) -> int:
	var nbCard : int = cardPile.get_child_count()
	if nbCard == 0:
		##TODO make somethings in this case 
		pass
	for card : Card in cardPile.get_children():
		card.setCardZone(destZone)
	return nbCard
func _on_graveyard_i_card_container_child_exiting_tree(node):
	var cardLeft = cardPile.get_child_count()
	remainingCardLabel.text = "[center]%s[center]" % str(cardLeft)
	if cardLeft == 0:
		cardOnTop.visible = false
	
func _on_tree_entered():
	cardPile = %CardPile
	cardOnTop = %CardOnTop
	remainingCardLabel = %RemainingCardLabel

func _on_card_on_top_tree_entered():
	pass # Replace with function body.
