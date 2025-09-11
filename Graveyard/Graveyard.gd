class_name Graveyard
extends Control

#@onready var graveyardCardContainer: MarginContainer = %GraveyardCardContainer
#@onready var lastCardLeft :RichTextLabel = %RemainingCardLabel
@onready var cardContainerNode : MarginContainer
@onready var cardOnTop : Card
@onready var remainingCardLabel : RichTextLabel
# types for key, info == nameCard : String, Dictonary(card: Card, nbCard : int}
var cardList : Dictionary

func sendToGraveyard(card : Card):
	cardContainerNode.add_child(card)
	card.visible = false
	cardOnTop.cardInfo = card.cardInfo
	cardOnTop.updateCardNode()
	cardOnTop.visible = true
	card.reparent(cardContainerNode)
	remainingCardLabel.text = "[center]%s[center]" % str(cardContainerNode.get_child_count() - 2)

func _on_graveyard_i_card_container_child_exiting_tree(node):
	var cardLeft = cardContainerNode.get_child_count() - 2
	remainingCardLabel.text = "[center]%s[center]" % str(cardLeft)
	if cardLeft == 0:
		cardOnTop.visible = false
	
func _on_tree_entered():
	cardContainerNode = %GraveyardICardContainer
	cardOnTop = %CardOnTop
	remainingCardLabel = %RemainingCardLabel

func _on_card_on_top_tree_entered():
	pass # Replace with function body.
