class_name Card
extends Control

signal cardCast(hotkeyCard : String)

var ClassCardInfo = preload("res://Cards/CardInfo.gd")

const pathCard = "res://ArtCard/"

@export var cardId: int
@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo
#it is the place in hand of the card
@onready var hotkeyCard : String : get = getHotkeyCard, set = setHotkeyCard 
## for checking which info changed and updating only the node of this info
@onready var bufferCardInfo: CardInfo = CardInfo.new()

## all nodes for all the infoCard display
@onready var nameCardLabel := $"%NameCardLabel"
@onready var costCardLabel := $"%CostCardLabel"
@onready var imageCard := $"%ImageTextureRect"
@onready var typeCardLabel := $"%TypeCardLabel"
@onready var descriptionCardLabel := $"%DescriptionCardLabel"
@onready var keyToUseLabel := $"%KeyToUseLabel"

func _input(input : InputEvent) -> void:
	if input.is_action_pressed(hotkeyCard):
		cardCast.emit(	hotkeyCard)

func getCardInfo() -> CardInfo:
	return cardInfo
	
func setCardInfo(nCardInfo: CardInfo) -> void:
	cardInfo = nCardInfo

#here parse the descriptiopn
func descritpionParsing() -> void:
	pass

func updateCardNode() -> void:
	if bufferCardInfo.name != cardInfo.name:
		nameCardLabel.text = cardInfo.name
		imageCard.texture = load(pathCard + cardInfo.name + ".png")
	if bufferCardInfo.cost != cardInfo.cost:
		costCardLabel.text =  "[center]%s[center]" % cardInfo.cost
	if bufferCardInfo.type != cardInfo.type:
		typeCardLabel.text = ClassCardInfo.CardType.keys()[cardInfo.type]
	if bufferCardInfo.description != cardInfo.description:
		descriptionCardLabel.text = cardInfo.description.replace(" | ", "\n")
	if keyToUseLabel.text != hotkeyCard:
		keyToUseLabel.text = "[center]%s[center]" % hotkeyCard

	bufferCardInfo = cardInfo
	
func _ready() -> void:
	updateCardNode()

func getHotkeyCard() -> String:
	return hotkeyCard

func determineHotkey(idCardHand : int) -> String:
	hotkeyCard = "castCard%s" % (idCardHand + 1)
	print("Key = ", hotkeyCard)
	return hotkeyCard

func setHotkeyCard(nKey) -> void:
	if hotkeyCard != nKey:
		hotkeyCard = nKey
		if keyToUseLabel != null:
			keyToUseLabel.text = "[center]%s[center]" % hotkeyCard
