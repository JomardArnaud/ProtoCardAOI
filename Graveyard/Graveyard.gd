class_name Graveyard
extends Control

const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var cardPile : Control = %CardPile
@onready var cardOnTop : Card = %CardOnTop
@onready var remainingCardLabel : RichTextLabel = %RemainingCardLabel

func sendToGraveyard(card : Card):
	card.visible = false
	cardOnTop.cardInfo = card.cardInfo
	cardOnTop.updateCardNode()
	cardOnTop.visible = true
	card.reparent(cardPile)
	remainingCardLabel.text = "[center]%s[/center]" % str(cardPile.get_child_count())

func emptyGraveyard(destZone: CardEnum.CardZone) -> int:
	var nbCard : int = cardPile.get_child_count()
	if nbCard == 0:
		##TODO make somethings in this case 
		pass
	for card : Card in cardPile.get_children().duplicate():
		card.setCardZone(destZone)
	return nbCard
	
func updateUI() -> void:
	var nbCardLeft = cardPile.get_child_count()
	remainingCardLabel.text = "[center]%s[/center]" % str(nbCardLeft)
	if nbCardLeft == 0:
		cardOnTop.visible = false

func _ready() -> void:
	cardPile.child_entered_tree.connect(onCardPileChanged)
	cardPile.child_exiting_tree.connect(onCardPileChanged)

func onCardPileChanged(_node: Node) -> void:
	updateUI.call_deferred()
