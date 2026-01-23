class_name Card
extends Control

const CardEnum = preload("res://Cards/CardEnum.gd")
const CardInfo = preload("res://Cards/CardInfo.gd")

signal casted()
signal resolved()
signal changeZone(card : Card, to : CardEnum.CardZone)

const pathCard = "res://ArtCard/"

@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo

@onready var commander : Commander :
	set(nCommander):
		commander = nCommander 
@onready var cardZone : CardEnum.CardZone : get = getCardZone, set = setCardZone
@onready var hotkeyCard : String : get = getHotkeyCard, set = setHotkeyCard

## for checking which info changed and updating only the node of this info
@onready var bufferCardInfo: CardInfo

## all nodes for all the infoCard display
@onready var nameCardLabel : RichTextLabel
@onready var costCardLabel : RichTextLabel
@onready var imageCard : TextureRect
@onready var typeCardLabel : RichTextLabel
@onready var descriptionCardLabel : RichTextLabel
@onready var keyToUseLabel : RichTextLabel

func cast() -> bool:
	if commander.commanderInfo.currentEnergy > cardInfo.cost:
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
		##TODO ne plus donner accès à tout le commandant à la carte mais plus lui passer une sorte de CommanderView(une struct avec des données genre nbCardAttackinHand et aussi tout les compossante que la carte pourrait avoir besoin pour modifier le commandeur, que le commander update à cahque frame)
		commander = nCommander
		setCardInfo(nInfo)
		changeZone.connect(nCommander.moveCard)
		costSetup()
		for i in range(0, nInfo.abilities.size()):
			var nAbility : CardAbilityNode = CardCollection.createAbility(nInfo.abilities[i])
			nAbility.caster = commander
			%Abilities.add_child(nAbility)
	else:
		push_error("no valid Commander was found")
	pass

func costSetup() -> void:
	pass


func updateCardNode() -> void:
	if (cardInfo == null):
		return
	if bufferCardInfo.name != cardInfo.name:
		nameCardLabel.text = cardInfo.name
		var path : String = pathCard + cardInfo.name + ".png"
		if !ResourceLoader.exists(path):
			path = pathCard + "Blank" + ".png"
		imageCard.texture = load(path)
	costCardLabel.text =  "[center]%s[center]" % cardInfo.cost
	typeCardLabel.text = CardEnum.CardType.keys()[cardInfo.type]
	##TODO faire une description dynamique à partir du cardInfo.Abilities
	#descriptionCardLabel.text = cardInfo.description.replace("|", "\n")
	keyToUseLabel.text = "[center]%s[center]" % hotkeyCard
	bufferCardInfo = cardInfo

func getHotkeyCard() -> String:
	return hotkeyCard

func setHotkeyCard(nKey : String) -> Card:
	hotkeyCard = nKey
	if keyToUseLabel != null:
		$PanelKey.visible = int(!hotkeyCard == "")
		keyToUseLabel.text = "[center]%s[center]" % hotkeyCard
	return self

func setCardZone(nZone : CardEnum.CardZone) -> void:
	if (cardZone != nZone):
		cardZone = nZone
		changeZone.emit(self, nZone)

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
