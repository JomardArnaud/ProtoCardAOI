class_name Card
extends Control

const cardScene : PackedScene = preload("res://Cards/Card.tscn") 
const CardInfo : Resource = preload("res://Cards/CardInfo.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")
const CardAbility = preload("res://Cards/Ability/CardAbility.gd")

signal cardCast(hotkeyUsed : String)
signal changeZone(card : Card, to : CardEnum.CardZone)

const pathCard = "res://ArtCard/"

@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo

@onready var player : PlayerController :
	set(nPlayer):
		player = nPlayer 
@onready var cardZone : CardEnum.CardZone : get = getCardZone, set = setCardZone
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
	if (cardZone == CardEnum.CardZone.SpellHand || cardZone == CardEnum.CardZone.PermanantHand):
		if input.is_action_pressed("Cast" + CardEnum.CardType.keys()[cardInfo.type] ):
			resolve()
			cardCast.emit(hotkeyCard)
	
func resolve() -> void:
	for ability in cardAbilities.values():
		ability.resolve()
	pass

func init(nPlayer : PlayerController, nInfo : CardInfo, nZone: CardEnum.CardZone = CardEnum.CardZone.Deck) -> void:
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
			var ability : CardAbility = load(path).new(player, parsedAbility[1])
			ability.init()
			cardAbilities[keyword] = ability
			add_child(ability)
		else:
			push_error(keyword, " Keyword's ability not find")
		
		#var abilityDict = CardKeyword.listKeyword.get(ability.get_slice(" ", 0))
		#var parsedAbily : PackedStringArray = ability.split(" ", true, 1)
		
		#keywords.call("plug" + parsedAbily[0],parsedAbily[1])
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
		typeCardLabel.text = CardEnum.CardType.keys()[cardInfo.type]
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

func setCardZone(nZone : CardEnum.CardZone) -> void:
	if (cardZone != nZone):
		changeZone.emit(self, nZone)
		cardZone = nZone
		match cardZone:
			CardEnum.CardZone.Graveyard:
				hotkeyCard = ""

func getCardZone() -> CardEnum.CardZone:
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
