class_name Hand
extends MarginContainer

const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var slotsCard : Dictionary[int, MarginContainer] = {
	CardEnum.CardType.DASH: %SlotDashContainer,
	CardEnum.CardType.ATTACK: %SlotAttackContainer,
	CardEnum.CardType.SPELL: %SlotSpellContainer
}

@onready var cardHandNode := %CardContainer
@onready var visibleHotkey : bool = false
var cardHand: Array[Card] = []

func setSlotCard(card: Card) -> void:
	card.reparent(slotsCard[card.cardInfo.type])

func addCardToHand(nCard: Card) -> void:
	if not is_instance_valid(nCard):
		return
	var indexCard : int
	if slotsCard[nCard.cardInfo.type].get_child_count() == 0:
			setSlotCard(nCard)
	else:
		cardHand.append(nCard)
		nCard.reparent(cardHandNode)
	updateHandHotkeys()
	nCard.visible = true
	
func fillSlotCard() -> void:
	var remainingCards: Array[Card] = []
	for card in cardHand:
		if not is_instance_valid(card) or card.cardZone != CardEnum.CardZone.Hand:
			continue
		if slotsCard[card.cardInfo.type].get_child_count() == 0:
			setSlotCard(card)
		else:
			remainingCards.append(card)
	cardHand = remainingCards
	updateHandHotkeys()
	
func getNbCardInHand() -> int:
	return cardHand.size() + getNbCardInSlot()

func castSlotCard(idSlot: int) -> void:
	if not slotsCard.has(idSlot):
		return
	var slotNode := slotsCard[idSlot]
	if slotNode.get_child_count() > 0:
		var cardToCast := slotNode.get_child(0) as Card
		if is_instance_valid(cardToCast):
			cardToCast.cast()
		
func castHandCard(index: int) -> void:
	if index < 0 or index >= cardHand.size():
		return
	var cardToCast := cardHand[index]
	if is_instance_valid(cardToCast):
		cardToCast.cast()

func updateHandHotkeys() -> void:
	if !visibleHotkey:
		return 
	for idSlot : int in slotsCard:
		if slotsCard[idSlot].get_child_count() > 0:
			var card = slotsCard[idSlot].get_child(0) as Card
			card.setHotkeyCard(InputManager.getHotkeyStr("Cast" + CardEnum.CardType.keys()[idSlot]))
	for i in range(cardHand.size()):
		if is_instance_valid(cardHand[i]):
			cardHand[i].setHotkeyCard(InputManager.getHotkeyStr("CastSlot" + str(i)))

func getNbCardInSlot() -> int:
	var nbCardInSlot : int = 0
	for slot : MarginContainer in slotsCard.values():
		if slot.get_child_count() > 0:
			nbCardInSlot += 1
	return nbCardInSlot

func setVisibleHotkey(nVisible: bool) -> void:
	visibleHotkey = nVisible
