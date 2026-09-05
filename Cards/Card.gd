class_name Card
extends Control

const CardEnum = preload("res://Cards/CardEnum.gd")
const CardInfo = preload("res://Cards/CardInfo.gd")

signal casted()
signal resolved()
signal changeZone(card : Card, to : CardEnum.CardZone)

const pathCard = "res://ArtCard/"

@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo
@export var freeCast : bool = false

@onready var commander : Commander : set = setCommander
@onready var cardZone : CardEnum.CardZone : get = getCardZone, set = setCardZone
@onready var hotkeyCard : String : get = getHotkeyCard, set = setHotkeyCard

@onready var nameCardLabel : RichTextLabel = %NameCardLabel
@onready var costCardLabel : RichTextLabel = %CostCardLabel
@onready var imageCard : TextureRect = %ImageTextureRect
@onready var typeCardLabel : RichTextLabel = %TypeCardLabel
@onready var descriptionCardLabel : RichTextLabel = %DescriptionCardLabel
@onready var keyToUseLabel : RichTextLabel = %KeyToUseLabel

var bufferCardInfo: CardInfo

func cast() -> bool:
	if commander && (commander.commanderInfo.currentEnergy >= cardInfo.cost || freeCast):
		if !freeCast:	
			commander.commanderInfo.currentEnergy -= cardInfo.cost
		casted.emit()
		resolve()
		return true
	return false

func resolve() -> void:
	for ability in %Abilities.get_children():
		if ability is CardAbilityNode:
			ability.resolve()
	resolved.emit()

func init(nCommander : Commander, nInfo : CardInfo, nZone: CardEnum.CardZone = CardEnum.CardZone.Deck) -> void:
	if nCommander != null && nCommander.cardHud != null:
		setCommander(nCommander)
		setCardInfo(nInfo)
		setCardZone(nZone)
		
		if !changeZone.is_connected(nCommander.moveCard):
			changeZone.connect(nCommander.moveCard)
			
		costSetup()
		
		for i in range(0, nInfo.abilities.size()):
			var nAbility : CardAbilityNode = CardCollection.createAbility(nInfo.abilities[i])
			nAbility.caster = commander
			%Abilities.add_child(nAbility)
	else:
		push_error("no valid Commander was found")

func costSetup() -> void:
	pass

func updateCardNode() -> void:
	if cardInfo == null:
		return
	if bufferCardInfo.name != cardInfo.name:
		nameCardLabel.text = cardInfo.name
		var path : String = pathCard + cardInfo.name + ".png"
		if !ResourceLoader.exists(path):
			path = pathCard + "Blank.png"
		imageCard.texture = load(path)
		
	costCardLabel.text = "[center]%s[center]" % cardInfo.cost
	typeCardLabel.text = CardEnum.CardType.keys()[cardInfo.type]
	keyToUseLabel.text = "[center]%s[center]" % hotkeyCard
	bufferCardInfo = cardInfo

func setCommander(nCommander: Commander) -> void:
	commander = nCommander

func getHotkeyCard() -> String:
	return hotkeyCard

func setHotkeyCard(nKey : String) -> Card:
	hotkeyCard = nKey
	if keyToUseLabel != null:
		$PanelKey.visible = !hotkeyCard.is_empty()
		keyToUseLabel.text = "[center]%s[center]" % hotkeyCard
	return self

func setCardZone(nZone : CardEnum.CardZone) -> void:
	if cardZone != nZone:
		cardZone = nZone
		changeZone.emit(self, nZone)

func getCardZone() -> CardEnum.CardZone:
	return cardZone
	
func getCardInfo() -> CardInfo:
	return cardInfo
	
func setCardInfo(nCardInfo: CardInfo) -> void:
	cardInfo = nCardInfo

func _ready() -> void:
	if bufferCardInfo == null:
		bufferCardInfo = CardInfo.new()
		updateCardNode()
