class_name Card
extends Control

const CardEnumClass = preload("res://Cards/CardEnum.gd")
const CardAbilityClass = preload("res://Cards/Ability/CardAbility.gd")

signal resolved()
signal changeZone(card : Card, to : CardEnumClass.CardZone)

const pathCard = "res://ArtCard/"

@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo

@onready var player : PlayerController :
	set(nPlayer):
		player = nPlayer 
@onready var cardZone : CardEnumClass.CardZone : get = getCardZone, set = setCardZone
@onready var hotkeyCard : String : get = getHotkeyCard, set = setHotkeyCard

var cardAbilities : Dictionary = {
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
	if hotkeyCard != "":
		if input.is_action_pressed("Cast" + CardEnumClass.CardType.keys()[cardInfo.type]):
			resolve()
	
func resolve() -> void:
	for ability in cardAbilities.values():
		ability.resolve()	
	resolved.emit()

func init(nPlayer : PlayerController, nInfo : CardInfo, nZone: CardEnumClass.CardZone = CardEnumClass.CardZone.Deck) -> void:
	player = nPlayer
	setCardInfo(nInfo)
	if nPlayer != null && nPlayer.has_node("CardHud"):
		var cardHudRef = nPlayer.get_node("CardHud")
		changeZone.connect(cardHudRef.moveCard)
		costSetup()
		descritpionParsing()

func costSetup() -> void:
	
	pass
	
#here parse the description

func descritpionParsing() -> void:
	var cardParsedAbilities = cardInfo.description.split(" | ")
	for abilityKeyword : String in cardParsedAbilities:
		var parsedAbility : PackedStringArray = abilityKeyword.split(" ", true, 1)
		var keyword : String = parsedAbility[0]
		var path = String("res://Cards/Ability/" + keyword + ".gd")
		if ResourceLoader.exists(path):
			var ability : CardAbility
			if parsedAbility.size() > 1:
				ability = load(path).new(player, parsedAbility[1])
			else : 
				ability = load(path).new(player, "")
			ability.init()
			cardAbilities[keyword] = ability
			add_child(ability)
		else:
			push_error(keyword, " Keyword's ability not find")

func updateCardNode() -> void:
	if (cardInfo == null):
		return
	if bufferCardInfo.name != cardInfo.name:
		nameCardLabel.text = cardInfo.name
		var path : String = pathCard + cardInfo.name + ".png"
		if !ResourceLoader.exists(path):
			path = pathCard + "Blank" + ".png"
		imageCard.texture = load(path)
	if bufferCardInfo.cost != cardInfo.cost:
		costCardLabel.text =  "[center]%s[center]" % cardInfo.cost
	if bufferCardInfo.type != cardInfo.type:
		typeCardLabel.text = CardEnumClass.CardType.keys()[cardInfo.type]
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

func setCardZone(nZone : CardEnumClass.CardZone) -> void:
	if (cardZone != nZone):
		changeZone.emit(self, nZone)
		cardZone = nZone
		match cardZone:
			CardEnumClass.CardZone.Graveyard:
				hotkeyCard = ""

func getCardZone() -> CardEnumClass.CardZone:
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
