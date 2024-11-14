class_name Card
extends Control

var ClassCardInfo = preload("res://Cards/CardInfo.gd")

const pathCard = "res://ArtCard/"

@export var cardId: int
@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo

## for checking which info changed and updating only the node of this info
@onready var bufferCardInfo: CardInfo = CardInfo.new()
## all nodes for all the infoCard display
@onready var nameCardLabel := $"%NameCardLabel"
@onready var costCardLabel := $"%CostCardLabel"
@onready var imageCard := $"%ImageTextureRect"
@onready var typeCardLabel := $"%TypeCardLabel"
@onready var descriptionCardLabel := $"%DescriptionCardLabel"
@onready var keyToUseLabel := $"%KeyToUseLabel"
#@onready var effect : Array

func getCardInfo() -> CardInfo:
	return cardInfo
	
func setCardInfo(nCardInfo: CardInfo) -> void:
	cardInfo = nCardInfo
	#descritpionParsing()

#here parse the descriptiopn
func descritpionParsing() -> void:
	pass

func updateCardNode() -> void:
	if bufferCardInfo.name != cardInfo.name:
		nameCardLabel.text = cardInfo.name
		imageCard.texture = load(pathCard + cardInfo.name + ".png")
	if bufferCardInfo.cost != cardInfo.cost:
		costCardLabel.text =  "[center]%s[center]"% cardInfo.cost
	if bufferCardInfo.type != cardInfo.type:
		typeCardLabel.text = ClassCardInfo.CardType.keys()[cardInfo.type]
	if bufferCardInfo.description != cardInfo.description:
		descriptionCardLabel.text = cardInfo.description.replace(" | ", "\n")

	bufferCardInfo = cardInfo
	
func _ready() -> void:
	updateCardNode()
