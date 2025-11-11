class_name Hand
extends MarginContainer
#
#const CardScene = preload("res://Cards/Card.tscn")
#const CardInfo = preload("res://Cards/CardInfo.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")

@export var handSizeLimit : int = 6

@onready var slotsCard : Dictionary[int, MarginContainer] = {
	CardEnum.CardType.DASH: %SlotDashContainer,
	CardEnum.CardType.ATTACK: %SlotAttackContainer,
	CardEnum.CardType.SPELL: %SlotSpellContainer
}

@onready var cardHandNode := %CardContainer
#Key of dict is hotkey to cast array<string, Card>
@onready var cardHand : Dictionary[int, Card] = {
}

#peut être trouver un meilleur nom
@onready var cdGlobalCast : float
	
func setSlotsCard():
	pass

func setSlotCard(card: Card) -> void:
	var strInput : String = "Cast" + CardEnum.CardType.keys()[card.cardInfo.type]
	card.setHotkeyCard(InputManager.get_instance().getHotkeyStr(strInput))
	card.reparent(slotsCard[card.cardInfo.type])

func addCardToHand(nCard: Card) -> void:
	var indexCard : int
	if slotsCard[nCard.cardInfo.type].get_child_count() == 0:
		setSlotCard(nCard)
		indexCard = nCard.cardInfo.type
	else:
		##TODO fix l'index card 
		indexCard = cardHand.size()
		nCard.hotkeyCard = String("Cast" + str(indexCard + 1))
		nCard.reparent(cardHandNode)
		cardHand[indexCard] = nCard
	nCard.visible = true

func fillSlotCard() -> void:
	var nbCardLeft : int = 0
	var offsetCardLeaving : int = 0
	var keySlotRef : Array[String]
	for i in range(0, cardHand.size()):
		var card : Card = cardHand[i]
		if !is_instance_valid(card):
			offsetCardLeaving += 1
			continue
		if slotsCard[card.cardInfo.type].get_child_count() == 0:
			offsetCardLeaving += 1
			var keyCard = cardHand.find_key(card)
			if keyCard != null:
				keySlotRef.push_back(keyCard)
			setSlotCard(card)
		else:
			cardHand.erase(i)
			cardHand[nbCardLeft] = card

func _process(delta: float) -> void:
	cdGlobalCast = clampf(cdGlobalCast - delta, 0, cdGlobalCast)

func cardLeaveHand(card: Card):
	var idCard = cardHand.find_key(card)
	if idCard!= null:
		cardHand[idCard] = null

##TODO opti here
func _on_slot_margin_child_exiting_tree(node: Node) -> void:
	#if node is Card:
		#cardLeaveHand(node)
	pass

func _on_slot_dash_container_child_exiting_tree(node: Node) -> void:
	if node is Card:
		cardLeaveHand(node)

func _on_slot_attack_container_child_exiting_tree(node: Node) -> void:
	if node is Card:
		cardLeaveHand(node)

func _on_slot_spell_container_child_exiting_tree(node: Node) -> void:
	if node is Card:
		cardLeaveHand(node)
