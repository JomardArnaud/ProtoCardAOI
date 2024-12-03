class_name Card
extends Control

const cardScene : PackedScene = preload("res://Cards/Card.tscn") 
const ClassCardInfo : Resource = preload("res://Cards/CardInfo.gd")

signal cardCast(from : CardInfo.CardZone)
signal changeZone(from : CardInfo.CardZone, to : CardInfo.CardZone)

const pathCard = "res://ArtCard/"

@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo
@onready var cardZone : CardInfo.CardZone : get = getCardZone, set = setCardZone
@onready var hotkeyCard : String : get = getHotkeyCard, set = setHotkeyCard 
## for checking which info changed and updating only the node of this info
@onready var bufferCardInfo: CardInfo

## all nodes for all the infoCard display
@onready var nameCardLabel : RichTextLabel 
#= %NameCardLabel
@onready var costCardLabel : RichTextLabel 
#= %CostCardLabel
@onready var imageCard : TextureRect
 #= %ImageTextureRect
@onready var typeCardLabel : RichTextLabel
 #= %TypeCardLabel
@onready var descriptionCardLabel : RichTextLabel
 #= %DescriptionCardLabel
@onready var keyToUseLabel : RichTextLabel
 #= %KeyToUseLabel

func _input(input : InputEvent) -> void:
	if input.is_action_released(hotkeyCard):
		print(cardZone)
		cardCast.emit(cardZone)
		
static func newCard(nInfo : CardInfo) -> Card:
	var nCard : Card = cardScene.instantiate()
	nCard.setCardInfo(nInfo)
	return nCard

#here parse the descriptiopn
func descritpionParsing() -> void:
	pass

func updateCardNode() -> void:
	if (cardInfo == null):
		return
	print(bufferCardInfo.name)
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

func getHotkeyCard() -> String:
	return hotkeyCard

func determineHotkey(idCardHand : int) -> String:
	hotkeyCard = str(idCardHand + 1)
	return hotkeyCard

func setHotkeyCard(nKey) -> void:
	if hotkeyCard != nKey:
		hotkeyCard = nKey
		if keyToUseLabel != null:
			keyToUseLabel.text = "[center]%s[center]" % hotkeyCard

func setZone(nZone) -> void:
	if (cardZone != nZone):
		changeZone.emit(cardZone, nZone)
		cardZone = nZone

func setCardZone(nZone : CardInfo.CardZone) -> void:
	if (cardZone != nZone):
		changeZone.emit(cardZone, nZone)
		cardZone = nZone

func getCardZone() -> CardInfo.CardZone:
	return cardZone
	
func getCardInfo() -> CardInfo:
	return cardInfo
	
func setCardInfo(nCardInfo: CardInfo) -> void:
	cardInfo = nCardInfo

func _on_tree_entered():
	bufferCardInfo = CardInfo.new()
	nameCardLabel = %NameCardLabel
	costCardLabel = %CostCardLabel
	imageCard = %ImageTextureRect
	typeCardLabel = %TypeCardLabel
	descriptionCardLabel = %DescriptionCardLabel
	keyToUseLabel = %KeyToUseLabel
	updateCardNode()
