extends Control

const pathCard = "res://ArtCard/"

@export var cardId: int
@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo

# for checking which info changed and updating only the node of this info
@onready var bufferCardInfo: CardInfo = CardInfo.new()
# all nodes for all the infoCard display
@onready var nameCardLabel = %NameCardLabel
@onready var costCardLabel = %CostCardLabel
@onready var imageCard = %ImageTextureRect
@onready var typeCardLabel = %TypeCardLabel
@onready var descriptionCardLabel = %DescriptionCardLabel
@onready var keyToUseLabel = %KeyToUseLabel
@onready var effect : Array

func getCardInfo() -> CardInfo:
	return cardInfo
	
func setCardInfo(nCardInfo: CardInfo) -> void:
	cardInfo = nCardInfo
	updateCardNode()

func updateCardNode() -> void:
	if bufferCardInfo.name != cardInfo.name:
		nameCardLabel.text = cardInfo.name
		imageCard.texture = load(pathCard + cardInfo.name + ".png")
	if bufferCardInfo.cost != cardInfo.cost:
		costCardLabel.text =  "[center]%s[center]"% cardInfo.cost
	if bufferCardInfo.type != cardInfo.type:
		typeCardLabel.text = cardInfo.type
	if bufferCardInfo.descption != cardInfo.descption:
		descriptionCardLabel.text = cardInfo.descption.replace(" | ", "\n")
		print(descriptionCardLabel.text)
			
	bufferCardInfo = cardInfo
	#
#func _ready() -> void:
	#if cardId < CardCollection.getCollection().size():
		#setCardInfo(CardCollection.collection[cardId])
	
