class_name Card
extends Control

const cardScene : PackedScene = preload("res://Cards/Card.tscn") 
const ClassCardInfo : Resource = preload("res://Cards/CardInfo.gd")
var keywords = load("res://Cards/CardKeyword.gd")

signal cardCast(hotkeyUsed : String)
signal changeZone(card : Card, to : CardInfo.CardZone)

const pathCard = "res://ArtCard/"

@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo
@export var returnTimer: float
@export var globalCdCost: float
@onready var cardZone : CardInfo.CardZone : get = getCardZone, set = setCardZone
@onready var hotkeyCard : String : get = getHotkeyCard, set = setHotkeyCard
#@onready var specialHotkeyCard : String : get = getSpecialHotkeyCard, set = setSpecialHotkeyCard
var cardAbilitiesInfo : Dictionary = {
}
## for checking which info changed and updating only the node of this info
@onready var bufferCardInfo: CardInfo

## all nodes for all the infoCard display
@onready var nameCardLabel : RichTextLabel
@onready var costCardLabel : RichTextLabel
@onready var imageCard : TextureRect
@onready var typeCardLabel : RichTextLabel
@onready var descriptionCardLabel : RichTextLabel
@onready var keyToUseLabel : RichTextLabel

func _input(input : InputEvent) -> void:
	if (cardZone == ClassCardInfo.CardZone.SpellHand || cardZone == ClassCardInfo.CardZone.PermanantHand):
		if input.is_action_released(hotkeyCard):
			cardCast.emit(hotkeyCard)
		
static func newCard(nInfo : CardInfo) -> Card:
	var nCard : Card = cardScene.instantiate()
	nCard.setCardInfo(nInfo)
	return nCard

func costParsing() -> void:
	var valueCD : PackedStringArray = cardInfo.cost.split("/")
	returnTimer = float(valueCD[0])
	globalCdCost = float(valueCD[1])
	pass
	
#here parse the descriptiopn
func descritpionParsing() -> void:
	var cardAbilities = cardInfo.description.rsplit("|")
	for ability : String in cardAbilities:
		var parsedAbily : PackedStringArray = ability.split(" ", true, 1)
		keywords.call("plug" + parsedAbily[0],parsedAbily[1])
		pass
	pass

func updateCardNode() -> void:
	if (cardInfo == null):
		return
	if bufferCardInfo.name != cardInfo.name:
		nameCardLabel.text = cardInfo.name
		imageCard.texture = load(pathCard + cardInfo.name + ".png")
	if bufferCardInfo.cost != cardInfo.cost:
		costCardLabel.text =  "[center]%s[center]" % cardInfo.cost
	if bufferCardInfo.type != cardInfo.type:
		typeCardLabel.text = cardInfo.type
		#typeCardLabel.text = ClassCardInfo.CardType.keys()[cardInfo.type]
	if bufferCardInfo.description != cardInfo.description:
		descriptionCardLabel.text = cardInfo.description.replace("|", "\n")
	if keyToUseLabel.text != hotkeyCard:
		keyToUseLabel.text = "[center]%s[center]" % hotkeyCard
	bufferCardInfo = cardInfo

func getHotkeyCard() -> String:
	return hotkeyCard

func setSpecialHotkeyCard(idCardHand : int) -> String:
	hotkeyCard = str(idCardHand + 1)
	return hotkeyCard

func setHotkeyCard(nKey : String) -> Card:
	hotkeyCard = nKey
	if keyToUseLabel != null:
		keyToUseLabel.text = "[center]%s[center]" % hotkeyCard
	return self

func setCardZone(nZone : CardInfo.CardZone) -> void:
	if (cardZone != nZone):
		changeZone.emit(self, nZone)
		cardZone = nZone
		match cardZone:
			CardInfo.CardZone.Graveyard:
				hotkeyCard = ""
				var nTimerReturn = Timer.new()
				nTimerReturn.one_shot = true
				nTimerReturn.wait_time = returnTimer
				nTimerReturn.autostart = true
				add_child(nTimerReturn)
				nTimerReturn.timeout.connect(func(): setCardZone(CardInfo.CardZone.SpellHand))

func getCardZone() -> CardInfo.CardZone:
	return cardZone
	
func getCardInfo() -> CardInfo:
	return cardInfo
	
func setCardInfo(nCardInfo: CardInfo) -> void:
	cardInfo = nCardInfo

func _on_tree_entered():
	if bufferCardInfo == null:
		bufferCardInfo = CardInfo.new()
		nameCardLabel = %NameCardLabel
		costCardLabel = %CostCardLabel
		imageCard = %ImageTextureRect
		typeCardLabel = %TypeCardLabel
		descriptionCardLabel = %DescriptionCardLabel
		keyToUseLabel = %KeyToUseLabel
		updateCardNode()
