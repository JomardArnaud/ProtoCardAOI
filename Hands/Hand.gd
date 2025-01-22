class_name Hand
extends MarginContainer

var CardScene = preload("res://Cards/Card.tscn")
var ClassCardInfo = preload("res://Cards/CardInfo.gd")

@export var handSizeLimit : int = 4

@onready var nbCardHand : int = 0
@onready var cardHandNode := %CardContainer
#Key of dict is hotkey to cast array<string, Card>
@onready var cardHand : Dictionary = {
}
## hand will always need a deck to work
@onready var deck : Deck
#peut être trouver un meilleur nom
@onready var cdGlobalCast : float

func castCardFromHand(hotkeyCard : String) -> void:
	if (cdGlobalCast > 0 || !cardHand.has(hotkeyCard)):
		return
	cdGlobalCast += cardHand[hotkeyCard].globalCdCost
	cardHand[hotkeyCard].setCardZone(CardInfo.CardZone.Graveyard)

func drawCard(nbCardDraw : int = 1) -> void:
	for i in range (0, nbCardDraw):
		var lastDrawnCard := deck.drawCard()
		if lastDrawnCard == null:
			return
		lastDrawnCard.setCardZone(CardInfo.CardZone.SpellHand)
		
func addCardToHand(nCard: Card) -> void:
	nCard.setHotkeyCard(str(cardHandNode.get_child_count() + 1))
	cardHand[nCard.getHotkeyCard()] = nCard
	nCard.visible = true
	if nCard.is_connected("cardCast", castCardFromHand):
		nCard.reparent(cardHandNode)
	else:
		nCard.cardCast.connect(castCardFromHand)
		cardHandNode.add_child(nCard)
	nbCardHand += 1

func setStartingHand(nDeck: Deck) -> void:
	deck = nDeck
	drawCard(handSizeLimit)

func _process(delta: float) -> void:
	cdGlobalCast = clampf(cdGlobalCast - delta, 0, cdGlobalCast)

func _on_card_container_child_exiting_tree(node):
	cardHand.clear()
	var minusAfterfindingNode : bool = false
	for i in range(0, cardHandNode.get_child_count()):
		var cardNode = cardHandNode.get_child(i)
		if (cardNode == node):
			minusAfterfindingNode = true
		else:
			cardNode.hotkeyCard = str(i + 1 - int(minusAfterfindingNode))
			cardHand[cardNode.hotkeyCard] = cardNode
