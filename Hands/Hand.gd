class_name Hand
extends MarginContainer

var CardScene = preload("res://Cards/Card.tscn")
var ClassCardInfo = preload("res://Cards/CardInfo.gd")

@export var handSizeLimit : int = 3

@onready var nbCardHand : int = 0
@onready var cardHandNode := %CardContainer
#Key of dict is hotkey to cast
@onready var cardHand : Dictionary = {
}
## hand will always need a deck to work
@onready var deck : Deck

func castCardFromHand(hotkeyCard : String) -> void:
	if (!cardHand.has(hotkeyCard)):
		push_error("hotkey of card not found in hand !")
		return
	cardHand[hotkeyCard].queue_free()
	#.queue_free()

func drawCard(nbCardDraw : int = 1) -> void:
	for i in range (0, nbCardDraw):
		var lastDrawnCardInfo := deck.drawCard()
		if lastDrawnCardInfo == null:
			return
		#tmp here card will emit the singal cardDrawn
		var lastDrawnCard : Card = CardScene.instantiate()
		lastDrawnCard.setCardInfo(lastDrawnCardInfo)
		if lastDrawnCard == null:
			return
		cardHand[lastDrawnCard.determineHotkey(i)] = lastDrawnCard
		cardHandNode.add_child(lastDrawnCard)
		lastDrawnCard.cardCast.connect(castCardFromHand)
		nbCardHand += 1
		
func setStartingHand(nDeck: Deck) -> void:
	deck = nDeck
	drawCard(handSizeLimit)	
