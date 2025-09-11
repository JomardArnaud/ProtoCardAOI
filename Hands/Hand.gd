class_name Hand
extends MarginContainer
#
#const CardScene = preload("res://Cards/Card.tscn")
#const CardInfo = preload("res://Cards/CardInfo.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")

@export var handSizeLimit : int = 4

@onready var slotsCard : Dictionary[int, MarginContainer] = {
	CardEnum.CardType.DASH: %SlotDashContainer,
	CardEnum.CardType.ATTACK: %SlotAttackContainer,
	CardEnum.CardType.SPELL: %SlotSpellContainer
}

@onready var nbCardHand : int = 0
@onready var cardHandNode := %CardContainer
#Key of dict is hotkey to cast array<string, Card>
@onready var cardHand : Dictionary[int, Card] = {
}
@onready var player : PlayerController :
	set(nPlayer):
		player = nPlayer 
## hand will always need a deck to work
@onready var deck : Deck
#peut être trouver un meilleur nom
@onready var cdGlobalCast : float

func castCardFromHand(hotkeyCard : String) -> void:
	#if (cdGlobalCast > 0 || !cardHand.has(hotkeyCard)):
		#return
	#cdGlobalCast += cardHand[hotkeyCard].globalCd.wait_time
	
	#cardHand[hotkeyCard].setCardZone(CardEnum.CardZone.Graveyard)
	pass
	
func drawCard(nbCardDraw : int = 1) -> void:
	for i in range (0, nbCardDraw):
		var lastDrawnCard := deck.drawCard()
		if lastDrawnCard == null:
			return
		lastDrawnCard.setCardZone(CardEnum.CardZone.Hand)

func setSlotsCard():
	pass

func addCardToHand(nCard: Card) -> void:
	var indexCard : int
	if slotsCard[nCard.cardInfo.type].get_child_count() == 0:
		var strInput : String = "Cast" + CardEnum.CardType.keys()[nCard.cardInfo.type]
		nCard.setHotkeyCard(InputManager.get_instance().getHotkeyStr(strInput))
		slotsCard[nCard.cardInfo.type].add_child(nCard)
		indexCard = nCard.cardInfo.type
	else:
		indexCard = cardHand.size() + CardEnum.CardType.size() + 1
		cardHandNode.add_child(nCard)
	cardHand[indexCard] = nCard
	nCard.visible = true
	nbCardHand += 1

func setStartingHand(nDeck: Deck) -> void:
	deck = nDeck
	drawCard(handSizeLimit)

func _process(delta: float) -> void:
	cdGlobalCast = clampf(cdGlobalCast - delta, 0, cdGlobalCast)

func _on_card_container_child_exiting_tree(node):
	cardHand[node] = null
