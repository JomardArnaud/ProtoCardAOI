# 🎮 Contexte du Projet Godot - Art Of Ida

## 📁 Arborescence des Fichiers
```text
ProtoCardAOI/
  project.godot
  ArtCard/
  Board/
    Board.gd
  Cards/
    Card.gd
    Card.tscn
    CardCollection.gd
    CardEnum.gd
    cardHudContainer.gd
    CardHudContainer.tscn
    CardInfo.gd
    Ability/
      Blank.gd
      CardAbilityInfo.gd
      CardAbilityNode.gd
      Dash.gd
      Gain.gd
      SkillShot.gd
      SkillShot/
        BasicProjectile.gd
        BasicProjectile.tscn
    Counters/
      Counter.gd
    CustomeTres/
  Commander/
    Commander.gd
    Commander.tscn
    CommanderInfo.gd
  Deck/
    Deck.gd
    Deck.tscn
  Enemies/
    Boss.gd
    Boss.tscn
    Scarecrow.gd
    Scarecrow.tscn
  Fonts/
  Graveyard/
    Graveyard.gd
    Graveyard.tscn
  Hand/
    Hand.gd
    Hand.tscn
    Slot.gd
    Slot.tscn
  Player/
    Player.tscn
    PlayerCamera.gd
    PlayerController.gd
    TunePanel.gd
  Scenes/
    BossFight.tscn
    MainScene.tscn
    test.tscn
  Utility/
    InputManager.gd
    InputManager.tscn
    CustomNode/
      Block2D.gd
      Block2D.tscn
      Feedback.gd
      Feedback.tscn
      Health.gd
      Health.tscn
      Hitbox2D.gd
      Hitbox2D.tscn
      HpBar.gd
      HpBar.tscn
      Hurtbox2D.gd
      Hurtbox2D.tscn
    CustomType/
      CPolygon2D.gd
      DamageBonusInfo.gd
      HealthInfo.gd
      MovementBody2D.gd
  Weapon/
    Cursor.gd
    Weapon.gd
    Weapon.tscn
    WeaponEnum.gd
    WeaponInfo.gd
```

## 📜 Contenu des Fichiers Clés

### 📄 `Board\Board.gd`

```gdscript
class_name Board
extends Node

```

### 📄 `Cards\Card.gd`

```gdscript
class_name Card
extends Control

const CardEnum = preload("res://Cards/CardEnum.gd")
const CardInfo = preload("res://Cards/CardInfo.gd")

signal casted()
signal resolved()
signal changeZone(card : Card, to : CardEnum.CardZone)

const pathCard = "res://ArtCard/"

@export var cardInfo: CardInfo : get = getCardInfo, set = setCardInfo

@onready var commander : Commander : set = setCommander
@onready var cardZone : CardEnum.CardZone : get = getCardZone, set = setCardZone
@onready var hotkeyCard : String : get = getHotkeyCard, set = setHotkeyCard

@onready var bufferCardInfo: CardInfo

@onready var nameCardLabel : RichTextLabel
@onready var costCardLabel : RichTextLabel
@onready var imageCard : TextureRect
@onready var typeCardLabel : RichTextLabel
@onready var descriptionCardLabel : RichTextLabel
@onready var keyToUseLabel : RichTextLabel

func cast() -> bool:
	if commander && commander.commanderInfo.currentEnergy >= cardInfo.cost:
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

```

### 📄 `Cards\Card.tscn`

```ini
[gd_scene load_steps=5 format=3 uid="uid://bt5ogw5ih2umq"]

[ext_resource type="Texture2D" uid="uid://cjqu3mwc5u7qs" path="res://ArtCard/Frame.png" id="1_2bqa0"]
[ext_resource type="Script" uid="uid://0naarwsblna5" path="res://Cards/Card.gd" id="2_gexrg"]
[ext_resource type="Theme" uid="uid://kbsu4ruo3khm" path="res://MainTheme.tres" id="3_gqpqm"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_srtxa"]
bg_color = Color(1, 1, 1, 0.329412)

[node name="Card" type="TextureRect"]
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -98.0
offset_top = -156.5
offset_right = 98.0
offset_bottom = 156.5
grow_horizontal = 2
grow_vertical = 2
theme = ExtResource("3_gqpqm")
texture = ExtResource("1_2bqa0")
expand_mode = 3
stretch_mode = 4
script = ExtResource("2_gexrg")

[node name="Name" type="MarginContainer" parent="."]
layout_mode = 1
anchors_preset = -1
anchor_left = 0.099
anchor_right = 0.594
anchor_bottom = 0.063
theme_override_constants/margin_left = 1
theme_override_constants/margin_top = 1
theme_override_constants/margin_right = 1
theme_override_constants/margin_bottom = 1
metadata/_edit_use_anchors_ = true

[node name="Panel" type="Panel" parent="Name"]
layout_mode = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_srtxa")

[node name="NameCardLabel" type="RichTextLabel" parent="Name"]
unique_name_in_owner = true
layout_mode = 2
focus_mode = 2
theme = ExtResource("3_gqpqm")
text = "Name's Card"
scroll_active = false
autowrap_mode = 0
selection_enabled = true
visible_characters_behavior = 1

[node name="Cost" type="MarginContainer" parent="."]
layout_mode = 1
anchors_preset = -1
anchor_left = 0.594
anchor_right = 0.901
anchor_bottom = 0.063
theme_override_constants/margin_left = 1
theme_override_constants/margin_top = 1
theme_override_constants/margin_right = 1
theme_override_constants/margin_bottom = 1
metadata/_edit_use_anchors_ = true

[node name="Panel" type="Panel" parent="Cost"]
layout_mode = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_srtxa")

[node name="CostCardLabel" type="RichTextLabel" parent="Cost"]
unique_name_in_owner = true
layout_mode = 2
theme = ExtResource("3_gqpqm")
bbcode_enabled = true
text = "[center]Cost[center]"
scroll_active = false
autowrap_mode = 0
visible_characters_behavior = 1

[node name="Image" type="MarginContainer" parent="."]
layout_mode = 1
anchors_preset = -1
anchor_left = 0.104
anchor_top = 0.063
anchor_right = 0.891
anchor_bottom = 0.5

[node name="ImageTextureRect" type="TextureRect" parent="Image"]
unique_name_in_owner = true
layout_mode = 2

[node name="Type" type="MarginContainer" parent="."]
layout_mode = 1
anchors_preset = -1
anchor_left = 0.099
anchor_top = 0.5
anchor_right = 0.891
anchor_bottom = 0.562

[node name="Panel" type="Panel" parent="Type"]
layout_mode = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_srtxa")

[node name="TypeCardLabel" type="RichTextLabel" parent="Type"]
unique_name_in_owner = true
layout_mode = 2
theme = ExtResource("3_gqpqm")
text = "Type's card"
scroll_active = false
autowrap_mode = 0
visible_characters_behavior = 1

[node name="Description" type="MarginContainer" parent="."]
layout_mode = 1
anchors_preset = -1
anchor_left = 0.099
anchor_top = 0.563
anchor_right = 0.891
anchor_bottom = 0.937

[node name="Panel" type="Panel" parent="Description"]
layout_mode = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_srtxa")

[node name="DescriptionCardLabel" type="RichTextLabel" parent="Description"]
unique_name_in_owner = true
layout_mode = 2
theme = ExtResource("3_gqpqm")
text = "Description's Card"
autowrap_mode = 1
visible_characters_behavior = 1

[node name="PanelKey" type="Panel" parent="."]
layout_mode = 1
anchors_preset = -1
anchor_top = 0.898
anchor_right = 1.0
anchor_bottom = 0.988
grow_horizontal = 2
grow_vertical = 2

[node name="KeyToUseLabel" type="RichTextLabel" parent="PanelKey"]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
theme_override_colors/default_color = Color(1, 1, 1, 1)
theme_override_font_sizes/normal_font_size = 15
bbcode_enabled = true
text = "[center]KeyToCast[center]"
scroll_active = false
scroll_following = true
shortcut_keys_enabled = false

[node name="Abilities" type="Node" parent="."]
unique_name_in_owner = true

[connection signal="tree_entered" from="." to="." method="_on_tree_entered"]

```

### 📄 `Cards\CardCollection.gd`

```gdscript
extends Node

const CardEnum = preload("res://Cards/CardEnum.gd")
const CardInfo = preload("res://Cards/CardInfo.gd")

func createAbility(infoAbility : CardAbilityInfo) -> CardAbilityNode:
	return infoAbility.createNode()

var collection : Dictionary[int, CardInfo] = {
	##TODO counter Shot, each ability with 'Shot' is resolve gain 1 counter Shot
#CardInfo.new("Ida's Wind", 0, CardEnum.CardType.ATTACK, [skillShot(10, 300), posio(5)])
	0: CardInfo.new("Ida's Wind", 0, CardEnum.CardType.ATTACK, {0: CardAbilityInfo.new("SkillShot", {"damage": 10, "speed": 2000, "projectileName": "BasicProjectile"})}),
	1: CardInfo.new("Wind rises", 1, CardEnum.CardType.DASH, {0: CardAbilityInfo.new("Dash", {"duration": 0.12, "power" : 3500})})
} : get = getCollection
	#1:  | Wind(1)"), ##TODO Counter 
	#2: CardInfo.new("Blank Attack", 1, CardEnum.CardType.ATTACK, "Blank"),
	#3: CardInfo.new("Blank Dash", 1, CardEnum.CardType.DASH, "Blank"),
	#4: CardInfo.new("Blank Spell", 1, CardEnum.CardType.SPELL, "Blank"),
	###TODO implemente keyword and X() synthax, AutoCast X _ (Card with AutoCast can't be send to SlotHand,   
	#5: CardInfo.new('IchiNoKata attack', 1, CardEnum.CardType.ATTACK, "FreeCost Dash | DashShot X(DashVelocity)"),
	#6: CardInfo.new('Hanabi attack', 0, CardEnum.CardType.ATTACK, "AutoCast  |  "),
	#7: CardInfo.new('Negation will', 0, CardEnum.CardType.SPELL, "Counter") # (Counter All) # Counter = Cancel X all effect from the last X type of card(can be all type)resolved within a time limit of 0.5 sec
	

func _init() -> void:
	fillCollection()

func getCollection():
	return collection

func getCardById(idCard: int):
	if !collection.has(idCard):
		printerr("%s isn't in the scope", idCard)
		return collection[0]
	return collection[idCard]
	
func fillCollection():
	print("Waiting collection to finishing collecting ...")
	print("Collection has finished")

```

### 📄 `Cards\CardEnum.gd`

```gdscript
extends Object

enum CardZone {
	Deck,
	Hand,
	Graveyard,
	Exile
}

enum CardType {
	DASH,
	ATTACK,
	SPELL
}

enum CardFamily {
	MODULE,
	CURSE
}

```

### 📄 `Cards\cardHudContainer.gd`

```gdscript
class_name CardHudContainer 
extends MarginContainer

@onready var deck : Deck = %Deck
@onready var hand : Hand = %Hand
@onready var graveyard : Graveyard = %Graveyard

```

### 📄 `Cards\CardHudContainer.tscn`

```ini
[gd_scene load_steps=5 format=3 uid="uid://bpxkfmkahlg3i"]

[ext_resource type="Script" uid="uid://dx4ajbag5xutg" path="res://Cards/cardHudContainer.gd" id="1_ptny2"]
[ext_resource type="PackedScene" uid="uid://ck5gdvd6jip1b" path="res://Deck/Deck.tscn" id="1_sq7jr"]
[ext_resource type="PackedScene" uid="uid://dculbgkisxgmq" path="res://Hand/Hand.tscn" id="2_ptny2"]
[ext_resource type="PackedScene" uid="uid://rbo8cq7hqtkg" path="res://Graveyard/Graveyard.tscn" id="3_w02rk"]

[node name="CardHudContainer" type="MarginContainer"]
offset_top = 830.0
offset_right = 1920.0
offset_bottom = 1080.0
size_flags_horizontal = 3
theme_override_constants/margin_left = 50
theme_override_constants/margin_right = 50
script = ExtResource("1_ptny2")

[node name="PanelHud" type="Panel" parent="."]
layout_mode = 2

[node name="MarginContainer" type="MarginContainer" parent="PanelHud"]
layout_mode = 1
anchors_preset = 7
anchor_left = 0.5
anchor_top = 1.0
anchor_right = 0.5
anchor_bottom = 1.0
offset_left = -810.0
offset_top = -250.0
offset_right = 810.0
grow_horizontal = 2
grow_vertical = 0

[node name="HBoxContainer" type="HBoxContainer" parent="PanelHud/MarginContainer"]
layout_mode = 2
theme_override_constants/separation = 50

[node name="Deck" parent="PanelHud/MarginContainer/HBoxContainer" instance=ExtResource("1_sq7jr")]
unique_name_in_owner = true
layout_mode = 2
size_flags_horizontal = 1
size_flags_vertical = 1

[node name="Hand" parent="PanelHud/MarginContainer/HBoxContainer" instance=ExtResource("2_ptny2")]
unique_name_in_owner = true
layout_mode = 2

[node name="Graveyard" parent="PanelHud/MarginContainer/HBoxContainer" instance=ExtResource("3_w02rk")]
unique_name_in_owner = true
layout_mode = 2
size_flags_horizontal = 4

[connection signal="child_entered_tree" from="PanelHud/MarginContainer/HBoxContainer/Graveyard" to="PanelHud/MarginContainer/HBoxContainer/Graveyard" method="_on_child_entered_tree"]

[editable path="PanelHud/MarginContainer/HBoxContainer/Hand"]

```

### 📄 `Cards\CardInfo.gd`

```gdscript
extends Resource

const CardEnum = preload("res://Cards/CardEnum.gd")

@export var name: String
@export var cost: int
@export var type: CardEnum.CardType
@export var family: String
@export var tag : Dictionary
@export var abilities: Dictionary[int, CardAbilityInfo]
	
func _init(nName="", nCost : int = 1, nType = CardEnum.CardType.DASH, nAbilities:Dictionary[int, CardAbilityInfo]={}):
	name = nName
	cost = nCost
	type = nType
	abilities = nAbilities

```

### 📄 `Cards\Ability\Blank.gd`

```gdscript
extends CardAbilityNode

signal blank()

func resolve() -> void:
	blank.emit()
	
func init() -> void:
	pass

```

### 📄 `Cards\Ability\CardAbilityInfo.gd`

```gdscript
class_name CardAbilityInfo
extends Resource

const PATH_ABILITY = "res://Cards/Ability/"

@export var abilityName: String 
@export var abiltyScript : GDScript
@export var param : Dictionary

func _init(nName: String = "", nParam: Dictionary = {}) -> void:
	if nName == "":
		push_error("Ability need name")
		return
	abilityName = nName
	var pathAbility = PATH_ABILITY + abilityName + ".gd"
	if ResourceLoader.exists(pathAbility):
		abiltyScript = load(pathAbility)
	else:
		push_error("Ability not found, path :" + pathAbility + "don't exist")
	param = nParam

func createNode() -> CardAbilityNode:
	if abiltyScript == null:
		push_error("No script loaded for ability: " + abilityName)
		return CardAbilityNode.new()
	var nAbility : CardAbilityNode = abiltyScript.new()
	nAbility.setupParam(param)
	return nAbility

```

### 📄 `Cards\Ability\CardAbilityNode.gd`

```gdscript
class_name CardAbilityNode
extends Node

var caster : Commander
var param : Dictionary

func resolve() -> void:
	pass

func setupParam(nParam: Dictionary) -> void:
	pass

```

### 📄 `Cards\Ability\Dash.gd`

```gdscript
extends CardAbilityNode

signal dash()

var defaultParam = {
	"duration" : 0.6,
	"power" : 3000
}

var durationTimer : Timer

func resolve() -> void:
	var dirDash : Vector2 = caster.getDirDash.call()
	caster.body.setDir(dirDash.normalized())
	caster.body.addSpeed(defaultParam.get("power"))
	caster.body.lockDir(true)
	durationTimer.start()
	
func _on_duration_timeout() -> void:
	caster.body.lockDir(false)
	caster.body.addSpeed(-defaultParam.get("power"))
	#caster.body.resetEnergy(Vector2(0.3, 0.3))

func setupParam(nParam: Dictionary) -> void:
	defaultParam.merge(nParam, true)
	if not durationTimer:
		durationTimer = Timer.new()
		durationTimer.one_shot = true
		durationTimer.wait_time = float(defaultParam.get("duration"))
		durationTimer.timeout.connect(_on_duration_timeout)
		add_child(durationTimer)

```

### 📄 `Cards\Ability\Gain.gd`

```gdscript
extends CardAbilityNode

signal Gain(stat: Variant)

var nbGain : int

func resolve() -> void:
	pass
	
func init() -> void:
	pass

```

### 📄 `Cards\Ability\SkillShot.gd`

```gdscript
extends CardAbilityNode

signal skillShot()

const PATH_PROJECTILE = "res://Cards/Ability/SkillShot/"

var defaultParam = {
	"speed": 2000,
	"damage" : 10,
	"radius" : 30,
	"projectileName": "BasicProjectile"
}

@onready var projectileScene : PackedScene

func resolve() -> void: 
	##TODO add a protection type by creating a projectile type
	var bullet : BasicProjectile = projectileScene.instantiate()
	var cursor : Cursor = caster.get_node("Cursor")
	bullet.dir = cursor.dir
	bullet.speed = defaultParam.speed
	bullet.damage = defaultParam.damage
	bullet.radius = defaultParam.radius
	bullet.position = cursor.global_position
	caster.add_child(bullet)
	
func setupParam(nParam: Dictionary) -> void:
	defaultParam.merge(nParam, true)
	var pathProjectile = PATH_PROJECTILE + defaultParam.get("projectileName") + ".tscn"
	if ResourceLoader.exists(pathProjectile):
		projectileScene = load(pathProjectile) as PackedScene

```

### 📄 `Cards\Ability\SkillShot\BasicProjectile.gd`

```gdscript
class_name BasicProjectile
extends Node2D 

@export var color : Color = Color(0,0,1,1)
@export var radius : float = 30 : set = setRadius
@export var speed : float = 3000
@export var damage : float = 10 :
	set(nDamage): damage = nDamage
@onready var dir : Vector2
@onready var collisionshape : CircleShape2D = $Hitbox/CollisionShape2D.shape
@onready var hitbox : Hitbox2D = $Hitbox

func _ready():
	set_as_top_level(true)
	queue_redraw()
	hitbox.connect("triggerArea", hit)
	
func _physics_process(delta: float) -> void:
	position += speed * dir * delta
	
func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func hit(collsionEntity: Node2D) -> void:
	collsionEntity.takeHit.emit(damage)
	
func setRadius(nRadius: float) -> void:
	radius = nRadius
	if (collisionshape != null):
		collisionshape.set_radius(nRadius)

func setDir(nDir: Vector2) -> void:
	dir = nDir

func setSpeed(nSpeed: float) -> void:
	speed = nSpeed

```

### 📄 `Cards\Ability\SkillShot\BasicProjectile.tscn`

```ini
[gd_scene load_steps=4 format=3 uid="uid://ceokhx3iv13ki"]

[ext_resource type="Script" uid="uid://bctbmfsem25qq" path="res://Cards/Ability/SkillShot/BasicProjectile.gd" id="1_wkcw8"]
[ext_resource type="PackedScene" uid="uid://b4btahiufqafh" path="res://Utility/CustomNode/Hitbox2D.tscn" id="2_1l6tr"]

[sub_resource type="CircleShape2D" id="CircleShape2D_w0ebm"]

[node name="BasicProjectile" type="Node2D"]
script = ExtResource("1_wkcw8")
speed = 0.0

[node name="Hitbox" parent="." instance=ExtResource("2_1l6tr")]
collision_layer = 8

[node name="CollisionShape2D" parent="Hitbox" index="0"]
shape = SubResource("CircleShape2D_w0ebm")

[editable path="Hitbox"]

```

### 📄 `Cards\Counters\Counter.gd`

```gdscript
extends Resource

enum idCounter {
	CWIND
}

func effectCWInd() -> void:
	
	return

```

### 📄 `Commander\Commander.gd`

```gdscript
class_name Commander
extends Node2D

const CardEnum = preload("res://Cards/CardEnum.gd")

@export var commanderInfo : CommanderInfo
@export var body : MovementBody2D
@export var cardHud : CardHudContainer
#@export var health : Health

##All HUD's parts
@onready var deck : Deck
@onready var hand : Hand
@onready var graveyard : Graveyard

var getDirDash : Callable
var getDirAttack : Callable

## TODO mettre le son "NEVER GIVE UP ! " en son de mort 
 
func _ready():
	deck = cardHud.deck
	hand = cardHud.hand
	graveyard = cardHud.graveyard
	deck.commander = self
	deck.cardAddedToDeck.connect(onCardAddedToDeck)
	deck.noMoreDraw.connect(refillDeck)
	deck.fillCardInDeck()
	while (hand.getNbCardInHand() < commanderInfo.nbCardStartingHand && deck.cardPile.get_child_count() > 0):
		drawCard()

func _process(delta: float) -> void:
	commanderInfo.currentEnergy += commanderInfo.energyRegen * delta
	
func moveCard(card : Card, to : CardEnum.CardZone) -> void:
	card.hotkeyCard = ""
	card.setCardZone(to)
	match to:
		CardEnum.CardZone.Deck:
			deck.sendToDeck(card)
		CardEnum.CardZone.Graveyard:
			graveyard.sendToGraveyard(card)
		CardEnum.CardZone.Hand:
			hand.addCardToHand(card)

func castSlotCard(idSlot : int):
	hand.castSlotCard(idSlot)

func castHandCard(idCard : int):
	hand.castHandCard(idCard)

func cardAfterResolve(card : Card):
	moveCard(card, CardEnum.CardZone.Graveyard)
	hand.fillSlotCard()
	drawCard()
	hand.fillSlotCard()

func refillDeck() -> void:
	var nbCard : int = graveyard.emptyGraveyard(CardEnum.CardZone.Deck)
	if nbCard == 0:
		##TODO make something in this case
		return
	deck.setNbCardLeft(nbCard)
	deck.shuffle()
	deck.call_deferred("drawCard")

func drawCard() -> void:
	if hand.getNbCardInHand() < commanderInfo.handSizeLimit && deck.cardPile:
		deck.drawCard()

func onCardAddedToDeck(nCard: Card):
	nCard.resolved.connect(cardAfterResolve.bind(nCard))

```

### 📄 `Commander\Commander.tscn`

```ini
[gd_scene load_steps=4 format=3 uid="uid://dsdq572poq71l"]

[ext_resource type="Script" uid="uid://cjnywahwqaso1" path="res://Commander/Commander.gd" id="1_bg122"]
[ext_resource type="Script" uid="uid://cqbsyfsqhulfn" path="res://Commander/CommanderInfo.gd" id="3_14x6c"]

[sub_resource type="Resource" id="Resource_ahofe"]
script = ExtResource("3_14x6c")
nbCardStartingHand = 6
handSizeLimit = 6
counter = Array[int]([])
currentEnergy = 2.0
energyRegen = 0.5

[node name="Commander" type="Node2D"]
script = ExtResource("1_bg122")
commanderInfo = SubResource("Resource_ahofe")

```

### 📄 `Commander\CommanderInfo.gd`

```gdscript
class_name CommanderInfo
extends Resource

signal energyChanged

const Counter = preload("res://Cards/Counters/Counter.gd") 

# CARD PART
## the next card which is drawn is the lastId
@export var nbCardStartingHand : int = 6
@export var handSizeLimit : int = 6
@export var counter : Array[Counter.idCounter]

@export var currentEnergy : float = 2
@export var energyRegen : float = 0.5 ## Per second

func setEnergy(nEnergy: float) -> void:
	currentEnergy = nEnergy
	emit_signal("energyChanged")

func useEnergy(costEnergy: float) -> void:
	setEnergy(currentEnergy - costEnergy) 

```

### 📄 `Deck\Deck.gd`

```gdscript
class_name Deck
extends Control

const CardInfo = preload("res://Cards/CardInfo.gd")
const CardNode = preload("res://Cards/Card.tscn")

signal noMoreDraw()
signal cardAddedToDeck(nCard : Card)

@export var cardCollection : CardCollection

@onready var commander : Commander :
	set(nCommander):
		commander = nCommander 
@onready var deckCardContainer : MarginContainer
@onready var labelRemainingCard : RichTextLabel
@onready var deckCardTexture : TextureRect

## the next card which is drawn is the lastId
var startingDeck : Dictionary[int, int] = {
	0: 3,
	1: 3,
	#2: 2,
	#3: 2,
	#4: 2
}
var deck: Array[Card]
var cardPile: Control
var nbCardLeft : int : set = setNbCardLeft

func addCardById(idCard: int) -> void:
	var infoCard : CardInfo = CardCollection.getCardById(idCard)
	var nCard = CardNode.instantiate()
	nCard.init(commander, infoCard)
	cardAddedToDeck.emit(nCard)
	deck.push_back(nCard)
	cardPile.add_child(nCard)

func fillCardInDeck() -> void:
	if startingDeck.is_empty():
		push_warning("No cards in starter deck")
		return
	for keyCard in startingDeck:
		#setting up info for card
		for i in range(0, startingDeck[keyCard]):
			addCardById(keyCard)
	shuffle()
	
func sendToDeck(nCard : Card) -> void:
	nCard.reparent(cardPile)
	deck.push_back(nCard)

func shuffle():
	deck.shuffle()

func drawCard() -> void:
	if nbCardLeft == 0:
		noMoreDraw.emit()
		return
	var cardDrawn : Card = deck.pop_back()
	cardDrawn.setCardZone(CardInfo.CardEnum.CardZone.Hand)

func setNbCardLeft(nLeft: int) -> void:
	nbCardLeft = nLeft
	#if nbCardLeft == 0:
		#deckCardTexture.visible = false
	#elif deckCardContainer.visible == false:
		#deckCardTexture.visible = true
	labelRemainingCard.text = "[center]" + str(nbCardLeft) + "[center]"

func _on_tree_entered():
	cardPile = %CardPile
	deckCardContainer = %DeckCardContainer
	deckCardTexture = %DeckCardTexture
	labelRemainingCard = %RemainingCardLabel

func _on_card_pile_child_entered_tree(node: Node) -> void:
	nbCardLeft += 1
	
func _on_card_pile_child_exiting_tree(node: Node) -> void:
	nbCardLeft -= 1

```

### 📄 `Deck\Deck.tscn`

```ini
[gd_scene load_steps=3 format=3 uid="uid://ck5gdvd6jip1b"]

[ext_resource type="Script" uid="uid://b6d7ujo63e5as" path="res://Deck/Deck.gd" id="1_et8v0"]
[ext_resource type="Texture2D" uid="uid://dky2jpf0yxba0" path="res://ArtCard/CardVerso.png" id="2_yo3bs"]

[node name="Deck" type="MarginContainer"]
anchors_preset = -1
anchor_right = 0.109
anchor_bottom = 0.231
offset_right = 0.719986
offset_bottom = 0.519989
size_flags_horizontal = 3
size_flags_vertical = 3
script = ExtResource("1_et8v0")

[node name="PanelContainer" type="PanelContainer" parent="."]
z_index = 1
layout_mode = 2

[node name="DeckCardContainer" type="MarginContainer" parent="PanelContainer"]
unique_name_in_owner = true
layout_mode = 2
theme_override_constants/margin_left = 10
theme_override_constants/margin_top = 10
theme_override_constants/margin_right = 10
theme_override_constants/margin_bottom = 10

[node name="DeckCardTexture" type="TextureRect" parent="PanelContainer/DeckCardContainer"]
unique_name_in_owner = true
layout_mode = 2
texture = ExtResource("2_yo3bs")
expand_mode = 3
stretch_mode = 5

[node name="CardPile" type="Control" parent="PanelContainer/DeckCardContainer"]
unique_name_in_owner = true
visible = false
layout_mode = 2

[node name="PanelContainer2" type="PanelContainer" parent="."]
z_index = 1
layout_mode = 2
size_flags_vertical = 8

[node name="VBoxContainer" type="VBoxContainer" parent="PanelContainer2"]
layout_mode = 2
size_flags_vertical = 8

[node name="DeckLabel" type="RichTextLabel" parent="PanelContainer2/VBoxContainer"]
z_index = 1
layout_mode = 2
size_flags_vertical = 8
theme_override_colors/default_color = Color(1, 1, 1, 1)
bbcode_enabled = true
text = "[center]DECK[center]"
fit_content = true
scroll_active = false
metadata/_edit_use_anchors_ = true

[node name="RemainingCardLabel" type="RichTextLabel" parent="PanelContainer2/VBoxContainer"]
unique_name_in_owner = true
z_index = 1
layout_mode = 2
size_flags_vertical = 8
theme_override_colors/default_color = Color(1, 1, 1, 1)
bbcode_enabled = true
text = "[center]8[center]"
fit_content = true
scroll_active = false
metadata/_edit_use_anchors_ = true

[connection signal="tree_entered" from="." to="." method="_on_tree_entered"]
[connection signal="child_entered_tree" from="PanelContainer/DeckCardContainer/CardPile" to="." method="_on_card_pile_child_entered_tree"]
[connection signal="child_exiting_tree" from="PanelContainer/DeckCardContainer/CardPile" to="." method="_on_card_pile_child_exiting_tree"]

```

### 📄 `Enemies\Boss.gd`

```gdscript
class_name Boss
extends MovementBody2D

@export var distanceToGet : float 
@export var player : PlayerController

var distanceToPlayer : float

func setPlayerInfo() -> void:
	pass

func _process(delta: float) -> void:
	setPlayerInfo()

```

### 📄 `Enemies\Boss.tscn`

```ini
[gd_scene load_steps=19 format=3 uid="uid://bm02wou48n2vd"]

[ext_resource type="Script" uid="uid://bnbcia1u5sxmg" path="res://Enemies/Boss.gd" id="1_o1tk4"]
[ext_resource type="Script" uid="uid://c8yac8xqlpbwr" path="res://Utility/CustomType/HealthInfo.gd" id="2_1454h"]
[ext_resource type="PackedScene" uid="uid://ca0b1qo2v7edf" path="res://Utility/CustomNode/Health.tscn" id="2_esarq"]
[ext_resource type="Texture2D" uid="uid://c5hiu5a7lapn4" path="res://ArtCard/Boss.png" id="3_esarq"]
[ext_resource type="PackedScene" uid="uid://bch12dvchox3r" path="res://Utility/CustomNode/Hurtbox2D.tscn" id="4_1454h"]
[ext_resource type="PackedScene" uid="uid://cs3gd7v8ubhmj" path="res://Utility/CustomNode/HpBar.tscn" id="5_esarq"]
[ext_resource type="PackedScene" uid="uid://dculbgkisxgmq" path="res://Hand/Hand.tscn" id="6_2st7e"]
[ext_resource type="PackedScene" uid="uid://ck5gdvd6jip1b" path="res://Deck/Deck.tscn" id="7_yjk0x"]

[sub_resource type="CircleShape2D" id="CircleShape2D_o1tk4"]
radius = 30.0

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_2st7e"]
bg_color = Color(0.6, 0.6, 0.6, 0)
draw_center = false
border_width_left = 5
border_width_top = 5
border_width_right = 5
border_width_bottom = 5
border_color = Color(0, 0.227451, 0.6, 1)

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_yjk0x"]
bg_color = Color(0.188235, 0.960784, 0.945098, 1)
border_width_left = 5
border_width_top = 5
border_width_right = 5
border_width_bottom = 5
border_color = Color(0.8, 0.8, 0.8, 0)

[sub_resource type="Theme" id="Theme_o1tk4"]
resource_local_to_scene = true
ProgressBar/styles/background = SubResource("StyleBoxFlat_2st7e")
ProgressBar/styles/fill = SubResource("StyleBoxFlat_yjk0x")

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_4pavk"]
bg_color = Color(0.6, 0.084, 0.084, 1)
border_width_left = 15
border_width_top = 15
border_width_right = 15
border_width_bottom = 15
border_color = Color(0, 0.0266666, 0.8, 1)

[sub_resource type="Resource" id="Resource_83a7f"]
resource_local_to_scene = true
script = ExtResource("2_1454h")
visibleHpBar = true
maxHealth = 100.0
health = 0.0
metadata/_custom_type_script = "uid://c8yac8xqlpbwr"

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_t78b6"]
bg_color = Color(0.6, 0.6, 0.6, 0)
draw_center = false
border_width_left = 5
border_width_top = 5
border_width_right = 5
border_width_bottom = 5
border_color = Color(0, 0.227451, 0.6, 1)

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_u5lg5"]
bg_color = Color(0.188235, 0.960784, 0.945098, 1)
border_width_left = 5
border_width_top = 5
border_width_right = 5
border_width_bottom = 5
border_color = Color(0.8, 0.8, 0.8, 0)

[sub_resource type="Theme" id="Theme_1454h"]
resource_local_to_scene = true
ProgressBar/styles/background = SubResource("StyleBoxFlat_t78b6")
ProgressBar/styles/fill = SubResource("StyleBoxFlat_u5lg5")

[sub_resource type="CircleShape2D" id="CircleShape2D_esarq"]
radius = 35.0892

[node name="Boss" type="CharacterBody2D"]
scale = Vector2(0.4, 0.4)
collision_layer = 128
collision_mask = 147
script = ExtResource("1_o1tk4")
metadata/_custom_type_script = "uid://xdbpkt3g5c08"

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
shape = SubResource("CircleShape2D_o1tk4")

[node name="BossHud" type="CanvasLayer" parent="."]

[node name="HpBarContainer" parent="BossHud" instance=ExtResource("5_esarq")]
anchors_preset = 5
anchor_left = 0.5
anchor_right = 0.5
anchor_bottom = 0.0
offset_left = -892.0
offset_top = 29.0
offset_right = 893.0
offset_bottom = 86.0
grow_vertical = 1
theme = SubResource("Theme_o1tk4")

[node name="HpBar" parent="BossHud/HpBarContainer" index="0"]
theme_override_colors/font_color = Color(0, 0, 0, 1)
theme_override_colors/font_outline_color = Color(0, 0, 0, 1)
theme_override_font_sizes/font_size = 30
theme_override_styles/fill = SubResource("StyleBoxFlat_4pavk")
show_percentage = true

[node name="HandMargin" parent="BossHud" instance=ExtResource("6_2st7e")]
anchors_preset = 8
anchor_top = 0.5
anchor_bottom = 0.5
offset_left = -228.0
offset_top = -441.0
offset_right = 244.0
offset_bottom = -219.0
grow_vertical = 2

[node name="Health" parent="." node_paths=PackedStringArray("hpBar") instance=ExtResource("2_esarq")]
visible = false
offset_left = 0.0
offset_top = -28.0
offset_right = 0.0
offset_bottom = -28.0
info = SubResource("Resource_83a7f")
hpBar = NodePath("../BossHud/HpBarContainer")

[node name="HpBar" parent="Health" index="0"]
visible = false
theme = SubResource("Theme_1454h")

[node name="MainSprite" type="Sprite2D" parent="."]
texture = ExtResource("3_esarq")

[node name="HurtBox" parent="." instance=ExtResource("4_1454h")]
collision_layer = 256
collision_mask = 8

[node name="CollisionShape2D" parent="HurtBox" index="0"]
shape = SubResource("CircleShape2D_esarq")

[node name="Deck" parent="." instance=ExtResource("7_yjk0x")]
visible = false
offset_left = 120.0
offset_top = 62.5
offset_right = 173.125
offset_bottom = 135.5

[connection signal="healthChanged" from="Health" to="BossHud/HpBarContainer" method="_on_health_health_changed"]
[connection signal="takeHit" from="HurtBox" to="Health" method="_on_hurt_box_take_hit"]

[editable path="BossHud/HpBarContainer"]
[editable path="BossHud/HandMargin"]
[editable path="Health"]
[editable path="HurtBox"]

```

### 📄 `Enemies\Scarecrow.gd`

```gdscript
class_name Scarecrow
extends Node2D

@export var cdRespawn : int = 1

func _on_health_health_drop_zero(infoHp: HealthInfo) -> void:
	visible = false
	await get_tree().create_timer(cdRespawn).timeout
	visible = true
	infoHp.heal(infoHp.maxHealth)

```

### 📄 `Enemies\Scarecrow.tscn`

```ini
[gd_scene load_steps=9 format=3 uid="uid://vbwrldk3i16e"]

[ext_resource type="Script" uid="uid://c4lylp40sxdo0" path="res://Enemies/Scarecrow.gd" id="1_tl5ag"]
[ext_resource type="Texture2D" uid="uid://d0ovc83hmo14j" path="res://ArtCard/Scarecrow.png" id="2_ydfl1"]
[ext_resource type="Script" uid="uid://d3yl2mqdykp0j" path="res://Utility/CustomType/CPolygon2D.gd" id="3_v4ya1"]
[ext_resource type="PackedScene" uid="uid://ca0b1qo2v7edf" path="res://Utility/CustomNode/Health.tscn" id="5_xl5xg"]
[ext_resource type="Script" uid="uid://c8yac8xqlpbwr" path="res://Utility/CustomType/HealthInfo.gd" id="6_1xilp"]
[ext_resource type="PackedScene" uid="uid://bch12dvchox3r" path="res://Utility/CustomNode/Hurtbox2D.tscn" id="6_x6itp"]

[sub_resource type="CapsuleShape2D" id="CapsuleShape2D_3jxnb"]
radius = 53.0
height = 134.0

[sub_resource type="Resource" id="Resource_u3xwy"]
resource_local_to_scene = true
script = ExtResource("6_1xilp")
visibleHpBar = true
maxHealth = 100.0
health = 80.0
metadata/_custom_type_script = "uid://c8yac8xqlpbwr"

[node name="Scarecrow" type="Node2D"]
script = ExtResource("1_tl5ag")

[node name="Sprite2D" type="Sprite2D" parent="."]
scale = Vector2(10, 10)
texture = ExtResource("2_ydfl1")

[node name="MovementBox" type="Polygon2D" parent="."]
visible = false
position = Vector2(-1.52542, 0)
scale = Vector2(1.05085, 1)
color = Color(1, 1, 1, 0)
polygon = PackedVector2Array(-14, -40, 13, -41, 30, -21, 21, 42, 20, -20, -29, -20)
script = ExtResource("3_v4ya1")

[node name="Timer" type="Timer" parent="."]
wait_time = 2.0
one_shot = true

[node name="HurtBox" parent="." instance=ExtResource("6_x6itp")]
collision_layer = 32

[node name="CollisionShape2D" parent="HurtBox" index="0"]
shape = SubResource("CapsuleShape2D_3jxnb")

[node name="Health" parent="." instance=ExtResource("5_xl5xg")]
offset_top = -97.0
offset_bottom = -72.0
info = SubResource("Resource_u3xwy")

[connection signal="takeHit" from="HurtBox" to="Health" method="_on_hurt_box_take_hit"]
[connection signal="healthDropZero" from="Health" to="." method="_on_health_health_drop_zero"]

[editable path="HurtBox"]

```

### 📄 `Graveyard\Graveyard.gd`

```gdscript
class_name Graveyard
extends Control

const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var cardPile : Control
@onready var cardOnTop : Card
@onready var remainingCardLabel : RichTextLabel

func sendToGraveyard(card : Card):
	card.visible = false
	cardOnTop.cardInfo = card.cardInfo
	cardOnTop.updateCardNode()
	cardOnTop.visible = true
	card.reparent(cardPile)
	remainingCardLabel.text = "[center]%s[center]" % str(cardPile.get_child_count())

func emptyGraveyard(destZone: CardEnum.CardZone) -> int:
	var nbCard : int = cardPile.get_child_count()
	if nbCard == 0:
		##TODO make somethings in this case 
		pass
	for card : Card in cardPile.get_children():
		card.setCardZone(destZone)
	return nbCard
	
func _on_tree_entered():
	cardPile = %CardPile
	cardOnTop = %CardOnTop
	remainingCardLabel = %RemainingCardLabel

func _on_card_on_top_tree_entered():
	pass # Replace with function body.

func _on_card_pile_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.

func _on_card_pile_child_exiting_tree(node: Node) -> void:
	var nbCardLeft = cardPile.get_child_count() - 1
	remainingCardLabel.text = "[center]%s[center]" % str(nbCardLeft)
	if nbCardLeft == 0:
		cardOnTop.visible = false

```

### 📄 `Graveyard\Graveyard.tscn`

```ini
[gd_scene load_steps=4 format=3 uid="uid://rbo8cq7hqtkg"]

[ext_resource type="Script" uid="uid://ctw24bejfrwct" path="res://Graveyard/Graveyard.gd" id="1_o2hnv"]
[ext_resource type="PackedScene" uid="uid://bt5ogw5ih2umq" path="res://Cards/Card.tscn" id="2_ara25"]
[ext_resource type="Texture2D" uid="uid://ck4115k25kn1n" path="res://ArtCard/Slot.png" id="3_4sgbr"]

[node name="Graveyard" type="MarginContainer"]
offset_left = 1247.0
offset_right = 1462.0
offset_bottom = 250.0
size_flags_horizontal = 3
size_flags_vertical = 3
script = ExtResource("1_o2hnv")

[node name="PanelContainer" type="PanelContainer" parent="."]
layout_mode = 2

[node name="GraveyardICardContainer" type="MarginContainer" parent="PanelContainer"]
unique_name_in_owner = true
layout_mode = 2
theme_override_constants/margin_left = 10
theme_override_constants/margin_top = 10
theme_override_constants/margin_right = 10
theme_override_constants/margin_bottom = 10

[node name="CardOnTop" parent="PanelContainer/GraveyardICardContainer" instance=ExtResource("2_ara25")]
unique_name_in_owner = true
visible = false
z_index = 1
layout_mode = 2
size_flags_horizontal = 4

[node name="TextureRect" type="TextureRect" parent="PanelContainer/GraveyardICardContainer"]
layout_mode = 2
texture = ExtResource("3_4sgbr")
expand_mode = 3
stretch_mode = 5

[node name="CardPile" type="Control" parent="PanelContainer/GraveyardICardContainer"]
unique_name_in_owner = true
layout_mode = 2

[node name="nameZonePanelContainer" type="PanelContainer" parent="."]
z_index = 4
layout_mode = 2
size_flags_vertical = 8

[node name="VBoxContainer" type="VBoxContainer" parent="nameZonePanelContainer"]
layout_mode = 2
size_flags_vertical = 8

[node name="nameZoneLabel" type="RichTextLabel" parent="nameZonePanelContainer/VBoxContainer"]
layout_mode = 2
size_flags_vertical = 8
bbcode_enabled = true
text = "[center]Graveyard[center]"
fit_content = true
scroll_active = false

[node name="RemainingCardLabel" type="RichTextLabel" parent="nameZonePanelContainer/VBoxContainer"]
unique_name_in_owner = true
layout_mode = 2
size_flags_vertical = 10
bbcode_enabled = true
text = "[center]0[center]"
fit_content = true
scroll_active = false
metadata/_edit_use_anchors_ = true

[connection signal="tree_entered" from="." to="." method="_on_tree_entered"]
[connection signal="child_exiting_tree" from="PanelContainer/GraveyardICardContainer" to="." method="_on_graveyard_i_card_container_child_exiting_tree"]
[connection signal="child_entered_tree" from="PanelContainer/GraveyardICardContainer/CardPile" to="." method="_on_card_pile_child_entered_tree"]
[connection signal="child_exiting_tree" from="PanelContainer/GraveyardICardContainer/CardPile" to="." method="_on_card_pile_child_exiting_tree"]

```

### 📄 `Hand\Hand.gd`

```gdscript
class_name Hand
extends MarginContainer
#const CardScene = preload("res://Cards/Card.tscn")
#const CardInfo = preload("res://Cards/CardInfo.gd")
const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var slotsCard : Dictionary[int, MarginContainer] = {
	CardEnum.CardType.DASH: %SlotDashContainer,
	CardEnum.CardType.ATTACK: %SlotAttackContainer,
	CardEnum.CardType.SPELL: %SlotSpellContainer
}

@onready var cardHandNode := %CardContainer
@onready var cardHand : Dictionary[int, Card] = {
}

#peut être trouver un meilleur nom
@onready var cdGlobalCast : float

func setSlotCard(card: Card) -> void:
	var strInput : String = "Cast" + CardEnum.CardType.keys()[card.cardInfo.type]
	card.setHotkeyCard(InputManager.getHotkeyStr(strInput))
	card.reparent(slotsCard[card.cardInfo.type])

func addCardToHand(nCard: Card) -> void:
	var indexCard : int
	if slotsCard[nCard.cardInfo.type].get_child_count() == 0:
		setSlotCard(nCard)
		indexCard = nCard.cardInfo.type
	else:
		##TODO fix l'index card 
		indexCard = cardHand.size()
		nCard.hotkeyCard = str(indexCard + 1)
		nCard.reparent(cardHandNode)
		cardHand[indexCard] = nCard
	nCard.visible = true
	
func fillSlotCard() -> void:
	var tmpCardHand : Dictionary[int, Card] = {}
	var nbCardHand : int = 0
	for i in range(0, cardHand.size()):
		var card : Card = cardHand[i]
		if card == null or !is_instance_valid(card) or card.cardZone != CardEnum.CardZone.Hand:
			continue
		if slotsCard[card.cardInfo.type].get_child_count() == 0:
			setSlotCard(card)
		else:
			var idCard = nbCardHand + 1
			card.hotkeyCard = str(nbCardHand + 1)
			tmpCardHand[nbCardHand] = card
			nbCardHand += 1
	cardHand = {}
	cardHand = tmpCardHand
	
func getNbCardInHand() -> int:
	return cardHand.size()

func castSlotCard(idSlot: int) -> void:
	if idSlot < 0 || idSlot > CardEnum.CardType.size():
		idSlot = 0
	if slotsCard[idSlot].get_child_count() > 0:
		slotsCard[idSlot].get_child(0).cast()
		
func castHandCard(idSlot: int) -> void:
	if idSlot < 0 || idSlot >= cardHand.size():
		idSlot = 0
	var cardToCast : Card = cardHand[idSlot]
	if cardToCast != null:
		cardToCast.cast()
	
func _process(delta: float) -> void:
	cdGlobalCast = clampf(cdGlobalCast - delta, 0, cdGlobalCast)

```

### 📄 `Hand\Hand.tscn`

```ini
[gd_scene load_steps=3 format=3 uid="uid://dculbgkisxgmq"]

[ext_resource type="Script" uid="uid://cwq1fet0mq2br" path="res://Hand/Hand.gd" id="1_us0oc"]
[ext_resource type="PackedScene" uid="uid://c2n7f34xdy4e2" path="res://Hand/Slot.tscn" id="2_hk34u"]

[node name="HandMargin" type="MarginContainer"]
anchors_preset = 5
anchor_left = 0.5
anchor_right = 0.5
offset_left = -752.0
offset_right = 752.0
offset_bottom = 361.0
grow_horizontal = 2
size_flags_horizontal = 3
script = ExtResource("1_us0oc")

[node name="HBoxContainer" type="HBoxContainer" parent="."]
layout_mode = 2

[node name="PanelContainer" type="PanelContainer" parent="HBoxContainer"]
layout_mode = 2
size_flags_horizontal = 3

[node name="MarginContainer" type="MarginContainer" parent="HBoxContainer/PanelContainer"]
layout_mode = 2
theme_override_constants/margin_top = 10
theme_override_constants/margin_bottom = 10

[node name="CardContainer" type="HBoxContainer" parent="HBoxContainer/PanelContainer/MarginContainer"]
unique_name_in_owner = true
layout_mode = 2
theme_override_constants/separation = 20
alignment = 1

[node name="SlotMargin" type="MarginContainer" parent="HBoxContainer/PanelContainer/MarginContainer/CardContainer"]
layout_mode = 2
theme_override_constants/margin_left = 10
theme_override_constants/margin_right = 10

[node name="HBoxContainer" type="HBoxContainer" parent="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin"]
layout_mode = 2
size_flags_horizontal = 0
theme_override_constants/separation = 20

[node name="SlotDash" parent="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer" instance=ExtResource("2_hk34u")]
layout_mode = 2

[node name="SlotDashContainer" type="MarginContainer" parent="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer/SlotDash"]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="SlotAttack" parent="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer" instance=ExtResource("2_hk34u")]
layout_mode = 2
typeSlot = "ATTACK"

[node name="SlotAttackContainer" type="MarginContainer" parent="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer/SlotAttack"]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="SlotSpell" parent="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer" instance=ExtResource("2_hk34u")]
layout_mode = 2
typeSlot = "SPELL"

[node name="SlotSpellContainer" type="MarginContainer" parent="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer/SlotSpell"]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[connection signal="child_exiting_tree" from="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin" to="." method="_on_slot_margin_child_exiting_tree"]
[connection signal="child_exiting_tree" from="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer/SlotDash/SlotDashContainer" to="." method="_on_slot_dash_container_child_exiting_tree"]
[connection signal="child_exiting_tree" from="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer/SlotAttack/SlotAttackContainer" to="." method="_on_slot_attack_container_child_exiting_tree"]
[connection signal="child_exiting_tree" from="HBoxContainer/PanelContainer/MarginContainer/CardContainer/SlotMargin/HBoxContainer/SlotSpell/SlotSpellContainer" to="." method="_on_slot_spell_container_child_exiting_tree"]

```

### 📄 `Hand\Slot.gd`

```gdscript
class_name Slot
extends TextureRect

@export var typeSlot : String = "DASH"

func _ready() -> void:
	%LabelType.text =  "[center]" + typeSlot + "[center]"

```

### 📄 `Hand\Slot.tscn`

```ini
[gd_scene load_steps=4 format=3 uid="uid://c2n7f34xdy4e2"]

[ext_resource type="Texture2D" uid="uid://ck4115k25kn1n" path="res://ArtCard/Slot.png" id="1_2wq1k"]
[ext_resource type="Theme" uid="uid://kbsu4ruo3khm" path="res://MainTheme.tres" id="2_qj8hf"]
[ext_resource type="Script" uid="uid://cv4spd5kxp002" path="res://Hand/Slot.gd" id="2_s8rqu"]

[node name="Slot" type="TextureRect"]
anchors_preset = -1
anchor_left = 0.449
anchor_top = 0.355
anchor_right = 0.551
anchor_bottom = 0.645
offset_left = -0.0800781
offset_top = 0.0999756
offset_right = 0.0799561
offset_bottom = -0.100037
grow_horizontal = 2
grow_vertical = 2
size_flags_vertical = 3
texture = ExtResource("1_2wq1k")
expand_mode = 3
script = ExtResource("2_s8rqu")

[node name="Panel" type="Panel" parent="."]
layout_mode = 1
anchors_preset = 14
anchor_top = 0.5
anchor_right = 1.0
anchor_bottom = 0.5
grow_horizontal = 2
grow_vertical = 2

[node name="LabelType" type="RichTextLabel" parent="Panel"]
unique_name_in_owner = true
layout_mode = 1
anchors_preset = 14
anchor_top = 0.5
anchor_right = 1.0
anchor_bottom = 0.5
offset_top = -11.5
offset_bottom = 11.5
grow_horizontal = 2
grow_vertical = 2
theme = ExtResource("2_qj8hf")
theme_override_colors/default_color = Color(1, 0.109804, 0.290196, 1)
theme_override_font_sizes/bold_italics_font_size = 30
theme_override_font_sizes/italics_font_size = 30
theme_override_font_sizes/mono_font_size = 30
theme_override_font_sizes/normal_font_size = 30
theme_override_font_sizes/bold_font_size = 30
bbcode_enabled = true
text = "[center]SlotTypeName[center]"
scroll_active = false
horizontal_alignment = 1
vertical_alignment = 1

```

### 📄 `Player\Player.tscn`

```ini
[gd_scene load_steps=14 format=3 uid="uid://1gqkb0fppjlj"]

[ext_resource type="Script" uid="uid://baaxvqbmq3gta" path="res://Player/PlayerController.gd" id="1_caob2"]
[ext_resource type="Texture2D" uid="uid://by8cxlc4pd4f0" path="res://ArtCard/SpritePlayerPlaygroundCard.png" id="4_le41p"]
[ext_resource type="PackedScene" uid="uid://d4ffh65mxnhar" path="res://Weapon/Weapon.tscn" id="5_q3f8m"]
[ext_resource type="Script" uid="uid://mmn6807ldqex" path="res://Player/TunePanel.gd" id="6_0j2ni"]
[ext_resource type="PackedScene" uid="uid://ca0b1qo2v7edf" path="res://Utility/CustomNode/Health.tscn" id="6_i4si5"]
[ext_resource type="Script" uid="uid://c8yac8xqlpbwr" path="res://Utility/CustomType/HealthInfo.gd" id="7_le41p"]
[ext_resource type="PackedScene" uid="uid://dsdq572poq71l" path="res://Commander/Commander.tscn" id="7_owyu7"]
[ext_resource type="PackedScene" uid="uid://bpxkfmkahlg3i" path="res://Cards/CardHudContainer.tscn" id="7_q3f8m"]
[ext_resource type="Script" uid="uid://cqbsyfsqhulfn" path="res://Commander/CommanderInfo.gd" id="8_q3f8m"]
[ext_resource type="Script" uid="uid://7jjqca4eb0e4" path="res://Utility/CustomNode/Hurtbox2D.gd" id="9_j23h2"]

[sub_resource type="CircleShape2D" id="CircleShape2D_qathd"]
radius = 4.41021

[sub_resource type="Resource" id="Resource_j23h2"]
script = ExtResource("7_le41p")
visibleHpBar = true
maxHealth = 100.0
health = 80.0
metadata/_custom_type_script = "uid://c8yac8xqlpbwr"

[sub_resource type="Resource" id="Resource_0j2ni"]
resource_local_to_scene = true
script = ExtResource("8_q3f8m")
nbCardStartingHand = 6
handSizeLimit = 6
counter = Array[int]([])
currentEnergy = 2.0
energyRegen = 0.5
metadata/_custom_type_script = "uid://cqbsyfsqhulfn"

[node name="Player" type="CharacterBody2D" groups=["Players"]]
scale = Vector2(10, 10)
collision_layer = 2
collision_mask = 147
script = ExtResource("1_caob2")

[node name="Movementbox" type="CollisionShape2D" parent="."]
shape = SubResource("CircleShape2D_qathd")

[node name="Sprite2D" type="Sprite2D" parent="."]
texture = ExtResource("4_le41p")

[node name="Weapon" parent="." node_paths=PackedStringArray("holder") instance=ExtResource("5_q3f8m")]
holder = NodePath("../Commander")

[node name="Health" parent="." instance=ExtResource("6_i4si5")]
offset_left = -9.3
offset_top = -9.4
offset_right = 83.7
offset_bottom = 9.6
scale = Vector2(0.2, 0.2)
info = SubResource("Resource_j23h2")

[node name="HUD" type="CanvasLayer" parent="."]

[node name="TurnerPanel" type="PanelContainer" parent="HUD" node_paths=PackedStringArray("player")]
process_mode = 3
offset_left = 688.0
offset_top = 295.0
offset_right = 1107.0
offset_bottom = 545.0
script = ExtResource("6_0j2ni")
player = NodePath("../..")

[node name="MarginContainer" type="MarginContainer" parent="HUD/TurnerPanel"]
layout_mode = 2

[node name="VBoxContainer" type="VBoxContainer" parent="HUD/TurnerPanel/MarginContainer"]
layout_mode = 2

[node name="SpeedText" type="RichTextLabel" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2
bbcode_enabled = true
text = "Speed :
"
fit_content = true

[node name="Speed" type="LineEdit" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2

[node name="AccelText" type="RichTextLabel" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2
text = "Accel :"
fit_content = true

[node name="Acceleration" type="LineEdit" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2

[node name="DecelText" type="RichTextLabel" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2
text = "Decel :"
fit_content = true

[node name="Deceleration" type="LineEdit" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2

[node name="InertiaText" type="RichTextLabel" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2
text = "Inertia (between (0,1) :"
fit_content = true

[node name="Inertia" type="LineEdit" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2

[node name="AccelUturnText" type="RichTextLabel" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2
text = "Accel Uturn (pour les demi-tour / Dot < 0) :
"
fit_content = true

[node name="UTurnAccel" type="LineEdit" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2

[node name="SteeringAccelText" type="RichTextLabel" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2
text = "Steering Accel = (pour les virages / Dot < 0.85) :"
fit_content = true

[node name="SteeringAccel" type="LineEdit" parent="HUD/TurnerPanel/MarginContainer/VBoxContainer"]
layout_mode = 2

[node name="CardContainer" parent="HUD" instance=ExtResource("7_q3f8m")]
anchors_preset = 7
anchor_left = 0.5
anchor_top = 1.0
anchor_right = 0.5
anchor_bottom = 1.0
offset_left = -960.0
offset_top = -250.0
offset_right = 960.0
offset_bottom = 0.0
grow_horizontal = 2
grow_vertical = 0

[node name="Commander" parent="." node_paths=PackedStringArray("body", "cardHud") instance=ExtResource("7_owyu7")]
commanderInfo = SubResource("Resource_0j2ni")
body = NodePath("..")
cardHud = NodePath("../HUD/CardContainer")

[node name="Hurtbox2D" type="Area2D" parent="."]
collision_layer = 4
collision_mask = 728
script = ExtResource("9_j23h2")
metadata/_custom_type_script = "uid://7jjqca4eb0e4"

[node name="CollisionShape2D" type="CollisionShape2D" parent="Hurtbox2D"]

[editable path="HUD/CardContainer"]
[editable path="HUD/CardContainer/PanelHud/MarginContainer/HBoxContainer/Hand"]
[editable path="Commander"]

```

### 📄 `Player\PlayerCamera.gd`

```gdscript
extends Camera2D

@export var speedCamera := 1.0 
@export var focusEntity: Node2D

@onready var focusOnEntityDoubleTap = 0

const smooth_lean := 10.0
const scale_lean  := 0.35

func _ready() -> void:
	position_smoothing_enabled = true
	position_smoothing_speed = 10.0
	if focusEntity:
		teleport_to_target()

func setFocusEntity(new_focus: Node2D) -> void:
	focusEntity = new_focus
	if is_node_ready() && focusEntity:
		teleport_to_target()

func teleport_to_target() -> void:
	if !focusEntity || !is_instance_valid(focusEntity):
		return
		
	position_smoothing_enabled = false
	global_position = focusEntity.global_position
	offset = Vector2.ZERO
	reset_smoothing()
	
	get_tree().process_frame.connect(
		func(): position_smoothing_enabled = true,
		CONNECT_ONE_SHOT
	)
	
func _process(delta: float) -> void:
	if !focusEntity || !is_instance_valid(focusEntity):
		return

	position = focusEntity.position

	var mouse_position := get_global_mouse_position()
	var direction_to_mouse := (mouse_position - position).normalized()
	var distance_to_mouse := mouse_position.distance_to(position)
	var lean := direction_to_mouse * distance_to_mouse * scale_lean

	offset = lerp(offset, lean, delta * smooth_lean)

```

### 📄 `Player\PlayerController.gd`

```gdscript
class_name PlayerController
extends MovementBody2D

const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var commander : Commander = $Commander
@onready var weapon : Weapon = $Weapon

var horizontalDirection : float
var verticalDirection : float

func _ready() -> void:
	commander.getDirAttack = getDirAttack
	commander.getDirDash = getDirDash

func updateDir() -> void:
	setDir(Vector2.ZERO)
	horizontalDirection = int(Input.is_action_pressed("moveLeft")) * -1 + int(Input.is_action_pressed("moveRight"))
	verticalDirection = int(Input.is_action_pressed("moveUp")) * -1 + int(Input.is_action_pressed("moveDown"))
	setDir(Vector2(horizontalDirection, verticalDirection))
		
func getDirDash() -> Vector2:
	return InputManager.getDirDash(self)
	
func getDirAttack() -> Vector2:
	return InputManager.getDirAttack(self)

func _process(delta: float) -> void:
	if weapon != null:
		weapon.setDirCursor(getDirAttack())

func _input(event: InputEvent) -> void:
	for keySlot in CardEnum.CardType.keys():
		if event.is_action_released("Cast" + keySlot):
			commander.castSlotCard(CardEnum.CardType[keySlot])
	for i in range(1, 7):
		if event.is_action_released("Cast" + str(i)):
			commander.castHandCard(i - 1)
	if Input.is_action_pressed("Shoot") && weapon != null:
		weapon.tryShoot()

```

### 📄 `Player\TunePanel.gd`

```gdscript
class_name TunerPanel
extends PanelContainer


@export var toggleKey : Key = KEY_TAB
@export var player : PlayerController

@onready var SpeedLine = $MarginContainer/VBoxContainer/Speed
@onready var AccelerationLine = $MarginContainer/VBoxContainer/Acceleration
@onready var DecelerationLine = $MarginContainer/VBoxContainer/Deceleration
@onready var InertiaLine = $MarginContainer/VBoxContainer/Inertia
@onready var UTurnAccelLine = $MarginContainer/VBoxContainer/UTurnAccel
@onready var SteeringAccelLine = $MarginContainer/VBoxContainer/SteeringAccel
@onready var playerMoveBox : MovementBody2D

func _ready() -> void:
	set_process_unhandled_input(true)
	hide()
	get_tree().paused = false
	if player != null && !player.is_node_ready():
		await player.ready
	if player != null && player.commander != null:
			playerMoveBox = player.commander.body
			
			#SpeedLine.text = str(playerMoveBox.speed)
			setupTuner()

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.pressed && not event.echo:
		if event.keycode == toggleKey:
			toggleTuner()

func toggleTuner() -> void:
	visible = !visible
	get_tree().paused = visible
	#if visible && player != null:
		#SpeedLine.text = str(playerMoveBox.speed)

func setupTuner() -> void:
	bindInput(SpeedLine, playerMoveBox.speed, func(nValueText): playerMoveBox.speed = nValueText)
	bindInput(AccelerationLine, playerMoveBox.acceleration, func(nValueText): playerMoveBox.acceleration = nValueText)
	bindInput(DecelerationLine, playerMoveBox.deceleration, func(nValueText): playerMoveBox.deceleration = nValueText)
	bindInput(InertiaLine, playerMoveBox.inertia, func(nValueText): playerMoveBox.inertia = nValueText)
	bindInput(UTurnAccelLine, playerMoveBox.uTurnAccel, func(nValueText): playerMoveBox.uTurnAccel = nValueText)
	bindInput(SteeringAccelLine, playerMoveBox.steeringAccel, func(nValueText): playerMoveBox.steeringAccel = nValueText)

func bindInput(inputLine: LineEdit, variableToSet : float, updateCallback:Callable) -> void:
	inputLine.text = str(variableToSet)
	var bufferValue : Array = [variableToSet]
	var applyValue = func():
		if inputLine.text.is_valid_float():
			var tmpValue = inputLine.text.to_float()
			if tmpValue != bufferValue[0]:
				bufferValue[0] = tmpValue
				updateCallback.call(tmpValue)
				Feedback.spawnFeedback(player, String(inputLine.name + "has been update to " + inputLine.text))
			else:
				inputLine.text = str(bufferValue[0])
	inputLine.text_submitted.connect(func(_nText: String) : applyValue.call())
	inputLine.focus_exited.connect(func() : applyValue.call())

```

### 📄 `Scenes\BossFight.tscn`

```ini
[gd_scene load_steps=6 format=3 uid="uid://bfxyiv3p7jta5"]

[ext_resource type="PackedScene" uid="uid://1gqkb0fppjlj" path="res://Player/Player.tscn" id="1_l5je7"]
[ext_resource type="Script" uid="uid://ci5fus18ojsoi" path="res://Utility/InputManager.gd" id="1_xjkry"]
[ext_resource type="Script" uid="uid://cuakmtonwohuw" path="res://Player/PlayerCamera.gd" id="2_xjkry"]
[ext_resource type="PackedScene" uid="uid://bm02wou48n2vd" path="res://Enemies/Boss.tscn" id="5_55aqt"]
[ext_resource type="PackedScene" uid="uid://dbostdu533m3l" path="res://Cards/CardCollection.tscn" id="5_xjkry"]

[node name="BossFight" type="Node2D"]

[node name="InputManager" type="Node" parent="."]
script = ExtResource("1_xjkry")
metadata/_custom_type_script = "uid://ci5fus18ojsoi"

[node name="Player" parent="." instance=ExtResource("1_l5je7")]
position = Vector2(430, 488)

[node name="Camera2D" type="Camera2D" parent="." node_paths=PackedStringArray("focusEntity")]
zoom = Vector2(0.5, 0.5)
script = ExtResource("2_xjkry")
focusEntity = NodePath("../Player")

[node name="Arena" type="Node" parent="."]

[node name="CardCollection" parent="." instance=ExtResource("5_xjkry")]

[node name="Boss" parent="." node_paths=PackedStringArray("player") instance=ExtResource("5_55aqt")]
position = Vector2(-928, -43)
scale = Vector2(10, 10)
player = NodePath("../Player")

```

### 📄 `Scenes\MainScene.tscn`

```ini
[gd_scene load_steps=10 format=3 uid="uid://d00sk2e54o4tg"]

[ext_resource type="Script" uid="uid://ci5fus18ojsoi" path="res://Utility/InputManager.gd" id="1_y4jh7"]
[ext_resource type="Script" uid="uid://cuakmtonwohuw" path="res://Player/PlayerCamera.gd" id="2_q68mp"]
[ext_resource type="PackedScene" uid="uid://b7kj234fqvhlm" path="res://Utility/CustomNode/Block2D.tscn" id="3_f140w"]
[ext_resource type="PackedScene" uid="uid://vbwrldk3i16e" path="res://Enemies/Scarecrow.tscn" id="4_0iob3"]
[ext_resource type="Script" uid="uid://5j4hdbin2nn7" path="res://Utility/CustomNode/Block2D.gd" id="5_4b75m"]
[ext_resource type="PackedScene" uid="uid://1gqkb0fppjlj" path="res://Player/Player.tscn" id="6_8ju71"]
[ext_resource type="Script" uid="uid://u8l3lxlg1glw" path="res://Cards/CardCollection.gd" id="7_q68mp"]
[ext_resource type="Script" uid="uid://cqbsyfsqhulfn" path="res://Commander/CommanderInfo.gd" id="8_f140w"]

[sub_resource type="Resource" id="Resource_0iob3"]
resource_local_to_scene = true
script = ExtResource("8_f140w")
nbCardStartingHand = 6
handSizeLimit = 6
counter = Array[int]([])
currentEnergy = 2.0
energyRegen = 0.5
metadata/_custom_type_script = "uid://cqbsyfsqhulfn"

[node name="MainScene" type="Node2D"]

[node name="InputManager" type="Node" parent="."]
script = ExtResource("1_y4jh7")
metadata/_custom_type_script = "uid://ci5fus18ojsoi"

[node name="Camera2D" type="Camera2D" parent="." node_paths=PackedStringArray("focusEntity")]
position = Vector2(-2222, 1800)
zoom = Vector2(0.5, 0.5)
position_smoothing_enabled = true
script = ExtResource("2_q68mp")
focusEntity = NodePath("../Player")

[node name="CardCollection" type="Node" parent="." groups=["CardCollection"]]
script = ExtResource("7_q68mp")
metadata/_custom_type_script = "uid://u8l3lxlg1glw"

[node name="Arena" type="Node" parent="."]

[node name="Polygon2D" parent="Arena" instance=ExtResource("3_f140w")]
position = Vector2(-639, -363)
polygon = PackedVector2Array(20, -1007, -1923, 585, -1397, 958, 623, -976)

[node name="Polygon2D2" parent="Arena" instance=ExtResource("3_f140w")]
position = Vector2(617, -855)
scale = Vector2(1.93187, 1.66827)
polygon = PackedVector2Array(-747.981, -284.725, 1220, 112, 1197, 226, -618.055, 23.3774)

[node name="Polygon2D3" parent="Arena" instance=ExtResource("3_f140w")]
position = Vector2(-888, -41.0001)
scale = Vector2(1.68824, 1.64685)
polygon = PackedVector2Array(-440, 274, 503, 952, 347, 955, -694, 207)

[node name="Polygon2D4" parent="Arena" instance=ExtResource("3_f140w")]
position = Vector2(-17.75, -1392.51)
scale = Vector2(1.33223, 2.67522)
polygon = PackedVector2Array(279, 960, 1360, 722, 1432, 804, -177.335, 1081.6)

[node name="Polygon2D5" parent="Arena" instance=ExtResource("3_f140w")]
position = Vector2(164, -261)
polygon = PackedVector2Array(1294, 921, 1129, -134, 1129, -872, 1649, -778, 1630, 1564)

[node name="Scarecrow" parent="Arena" instance=ExtResource("4_0iob3")]
position = Vector2(1085, 17)

[node name="Scarecrow2" parent="Arena" instance=ExtResource("4_0iob3")]
position = Vector2(-544, 714)

[node name="Scarecrow3" parent="Arena" instance=ExtResource("4_0iob3")]
position = Vector2(-412, -425)

[node name="Scarecrow4" parent="Arena" instance=ExtResource("4_0iob3")]
position = Vector2(-514, -443)

[node name="Scarecrow5" parent="Arena" instance=ExtResource("4_0iob3")]
position = Vector2(-521, -334)

[node name="Block2D" type="Polygon2D" parent="Arena"]
position = Vector2(-2797, 1477)
polygon = PackedVector2Array(2106, -1026, 2034, -936, 2256, -876, 2352, -1038)
script = ExtResource("5_4b75m")

[node name="Block2D2" type="Polygon2D" parent="Arena"]
position = Vector2(-2467, 1615)
polygon = PackedVector2Array(2095, -1094, 2006, -974, 2256, -876, 2352, -1038, 2432, -1126)
script = ExtResource("5_4b75m")

[node name="Player" parent="." instance=ExtResource("6_8ju71")]
inertia = 0.15

[node name="Commander" parent="Player" index="5"]
commanderInfo = SubResource("Resource_0iob3")

[editable path="Player"]
[editable path="Player/HUD/CardContainer"]
[editable path="Player/HUD/CardContainer/PanelHud/MarginContainer/HBoxContainer/Hand"]
[editable path="Player/Commander"]

```

### 📄 `Scenes\test.tscn`

```ini
[gd_scene load_steps=2 format=3 uid="uid://fap37dey25ld"]

[ext_resource type="PackedScene" uid="uid://1gqkb0fppjlj" path="res://Player/Player.tscn" id="1_lc1oi"]

[node name="Test" type="Node2D"]

[node name="Player" parent="." instance=ExtResource("1_lc1oi")]

```

### 📄 `Utility\InputManager.gd`

```gdscript
extends Node

func getHotkeyStr(strInput: String) -> String:
	if InputMap.has_action(strInput):
		var events = InputMap.action_get_events(strInput)
		if events != null && !events.is_empty():
			return events[0].as_text().split(" ")[0]
	return ""

func getDirAttack(player: PlayerController) -> Vector2:
	return getDirFromMouse(player).normalized()
 
func getDirDash(player: PlayerController) -> Vector2:
	return getDirFromMouse(player).normalized()

func getDirFromMouse(entity: Node) -> Vector2:
	if !entity || !is_instance_valid(entity):
		return Vector2.ZERO
	var destDir : Vector2
	destDir = entity.get_global_mouse_position() - entity.global_position
	if destDir.length_squared() > 0.0001: 
		return destDir.normalized()
	return Vector2.ZERO

```

### 📄 `Utility\InputManager.tscn`

```ini
[gd_scene format=3 uid="uid://btjil1vrqgpgx"]

[node name="InputManager" type="Node2D"]

```

### 📄 `Utility\CustomNode\Block2D.gd`

```gdscript
class_name Block2D
extends CPolygon2D

func _ready():
	setBodyFromPolygon(polygon)

```

### 📄 `Utility\CustomNode\Block2D.tscn`

```ini
[gd_scene load_steps=2 format=3 uid="uid://b7kj234fqvhlm"]

[ext_resource type="Script" uid="uid://5j4hdbin2nn7" path="res://Utility/CustomNode/Block2D.gd" id="1_amoyq"]

[node name="Polygon2D" type="Polygon2D"]
script = ExtResource("1_amoyq")

```

### 📄 `Utility\CustomNode\Feedback.gd`

```gdscript
class_name Feedback
extends CanvasLayer

const sceneFeedback = preload("res://Utility/CustomNode/Feedback.tscn")

@export var timeBeforeFading : float = 0.5
@export var durationFade : float = 1
@export var text : String : set = setText

@onready var textNode : RichTextLabel = $PanelContainer/MarginContainer/RichTextLabel
@onready var panelContainer : PanelContainer = $PanelContainer

static func spawnFeedback(owner: Node, nText : String) -> Feedback:
	var nFeedback = sceneFeedback.instantiate() as Feedback
	nFeedback.text = nText
	owner.add_child(nFeedback)
	return nFeedback

func _ready() -> void:
	updateUI()
	popUp()

func setText(nText: String) -> void:
	text = nText
	if is_node_ready():
		updateUI() 

func popUp() -> void:
	panelContainer.modulate.a = 1
	var tween = create_tween()
	tween.tween_interval(timeBeforeFading)
	tween.tween_property(panelContainer, "modulate:a", 0.0, durationFade)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)

func updateUI() -> void:
	textNode.text = "[center]%s[/center]" % text

```

### 📄 `Utility\CustomNode\Feedback.tscn`

```ini
[gd_scene load_steps=2 format=3 uid="uid://01n0p7fdgvih"]

[ext_resource type="Script" uid="uid://dxv8d3djhb8ox" path="res://Utility/CustomNode/Feedback.gd" id="1_oddg0"]

[node name="Feedback" type="CanvasLayer"]
process_mode = 3
script = ExtResource("1_oddg0")

[node name="PanelContainer" type="PanelContainer" parent="."]
anchors_preset = 5
anchor_left = 0.5
anchor_right = 0.5
offset_left = -162.5
offset_top = 30.0
offset_right = 162.5
offset_bottom = 73.0
grow_horizontal = 2

[node name="MarginContainer" type="MarginContainer" parent="PanelContainer"]
layout_mode = 2
size_flags_horizontal = 4
size_flags_vertical = 0
theme_override_constants/margin_left = 10
theme_override_constants/margin_top = 10
theme_override_constants/margin_right = 10
theme_override_constants/margin_bottom = 10

[node name="RichTextLabel" type="RichTextLabel" parent="PanelContainer/MarginContainer"]
layout_mode = 2
bbcode_enabled = true
text = "geeggeesvvsadvdsvsdvssdvsdvsdsvsvsv"
fit_content = true
scroll_active = false
autowrap_mode = 0
horizontal_alignment = 1
vertical_alignment = 1

```

### 📄 `Utility\CustomNode\Health.gd`

```gdscript
class_name Health
extends Control

signal healthChanged(nHealth: float)
signal healthDropZero(selfInfo : HealthInfo)

@export var info : HealthInfo
@export var hpBar : HpBar

func _ready() -> void:
	if (hpBar == null):
		hpBar = $HpBar
	else:
		$HpBar.queue_free()
	if (info == null):
		push_error("no health info found")
		return
	info.infoChanged.connect(hpBar.updateHpBarNode.bind(info))
	info.healthDropZero.connect(onHealthDropZero)
	hpBar.updateHpBarNode(info)	
	
func onHealthDropZero() -> void:
	healthDropZero.emit(info)

func _on_hurt_box_take_hit(damage: float) -> void:
	info.takeDamage(damage) # Replace with function body.

```

### 📄 `Utility\CustomNode\Health.tscn`

```ini
[gd_scene load_steps=6 format=3 uid="uid://ca0b1qo2v7edf"]

[ext_resource type="Script" uid="uid://dwn8vj1wxy6cs" path="res://Utility/CustomNode/Health.gd" id="1_qvcda"]
[ext_resource type="PackedScene" uid="uid://cs3gd7v8ubhmj" path="res://Utility/CustomNode/HpBar.tscn" id="3_jx60x"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_t78b6"]
bg_color = Color(0.6, 0.6, 0.6, 0)
draw_center = false
border_width_left = 5
border_width_top = 5
border_width_right = 5
border_width_bottom = 5
border_color = Color(0, 0.227451, 0.6, 1)

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_u5lg5"]
bg_color = Color(0.188235, 0.960784, 0.945098, 1)
border_width_left = 5
border_width_top = 5
border_width_right = 5
border_width_bottom = 5
border_color = Color(0.8, 0.8, 0.8, 0)

[sub_resource type="Theme" id="Theme_vwrp0"]
resource_local_to_scene = true
ProgressBar/styles/background = SubResource("StyleBoxFlat_t78b6")
ProgressBar/styles/fill = SubResource("StyleBoxFlat_u5lg5")

[node name="Health" type="MarginContainer"]
anchors_preset = 5
anchor_left = 0.5
anchor_right = 0.5
offset_left = -100.0
offset_right = 100.0
offset_bottom = 25.0
grow_horizontal = 2
size_flags_horizontal = 4
size_flags_vertical = 4
script = ExtResource("1_qvcda")

[node name="HpBar" parent="." instance=ExtResource("3_jx60x")]
layout_mode = 2
theme = SubResource("Theme_vwrp0")

[connection signal="ready" from="HpBar" to="." method="_on_hp_bar_ready"]

```

### 📄 `Utility\CustomNode\Hitbox2D.gd`

```gdscript
class_name Hitbox2D
extends Area2D

signal triggerArea(area)

func _on_area_entered(area: Area2D) -> void:
	emit_signal("triggerArea", area)
	owner.queue_free()

func _on_body_entered(body: Node2D) -> void:
	owner.queue_free()

```

### 📄 `Utility\CustomNode\Hitbox2D.tscn`

```ini
[gd_scene load_steps=2 format=3 uid="uid://b4btahiufqafh"]

[ext_resource type="Script" uid="uid://o1dykyd5hy7k" path="res://Utility/CustomNode/Hitbox2D.gd" id="1_71hna"]

[node name="HitboxShape" type="Area2D"]
collision_layer = 0
collision_mask = 292
script = ExtResource("1_71hna")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]

[connection signal="area_entered" from="." to="." method="_on_area_entered"]
[connection signal="body_entered" from="." to="." method="_on_body_entered"]

```

### 📄 `Utility\CustomNode\HpBar.gd`

```gdscript
class_name HpBar
extends MarginContainer

@onready var hpBar : ProgressBar

func _ready() -> void:
	hpBar = $HpBar

func updateHpBarNode(info: HealthInfo) -> void:
	if info != null:
		if (hpBar.visible != info.visibleHpBar):
			hpBar.visible = info.visibleHpBar
		if (hpBar.max_value != info.maxHealth):
			hpBar.max_value = info.maxHealth
		if (hpBar.value != info.health):
			hpBar.set_value(info.health)

```

### 📄 `Utility\CustomNode\HpBar.tscn`

```ini
[gd_scene load_steps=5 format=3 uid="uid://cs3gd7v8ubhmj"]

[ext_resource type="Script" uid="uid://ds8p30b5amh1f" path="res://Utility/CustomNode/HpBar.gd" id="1_4d1f5"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_2st7e"]
bg_color = Color(0.6, 0.6, 0.6, 0)
draw_center = false
border_width_left = 5
border_width_top = 5
border_width_right = 5
border_width_bottom = 5
border_color = Color(0, 0.227451, 0.6, 1)

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_yjk0x"]
bg_color = Color(0.188235, 0.960784, 0.945098, 1)
border_width_left = 5
border_width_top = 5
border_width_right = 5
border_width_bottom = 5
border_color = Color(0.8, 0.8, 0.8, 0)

[sub_resource type="Theme" id="Theme_cl172"]
resource_local_to_scene = true
ProgressBar/styles/background = SubResource("StyleBoxFlat_2st7e")
ProgressBar/styles/fill = SubResource("StyleBoxFlat_yjk0x")

[node name="HpBarContainer" type="MarginContainer"]
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
size_flags_horizontal = 3
size_flags_vertical = 3
theme = SubResource("Theme_cl172")
script = ExtResource("1_4d1f5")

[node name="HpBar" type="ProgressBar" parent="."]
layout_mode = 2
size_flags_vertical = 1
value = 100.0
show_percentage = false

```

### 📄 `Utility\CustomNode\Hurtbox2D.gd`

```gdscript
class_name Hurtbox2D
extends Area2D

signal takeHit(damage : float)

##TODO like health try to find a TakeHit function from parent and connect to hit 
func _ready() -> void:
	var parent = get_parent()
	if (parent.has_method("onTakeHit")):
		takeHit.connect(parent.onTakeHit.bind())

```

### 📄 `Utility\CustomNode\Hurtbox2D.tscn`

```ini
[gd_scene load_steps=2 format=3 uid="uid://bch12dvchox3r"]

[ext_resource type="Script" uid="uid://7jjqca4eb0e4" path="res://Utility/CustomNode/Hurtbox2D.gd" id="1_nf5k1"]

[node name="HurtBox" type="Area2D"]
collision_layer = 0
collision_mask = 584
script = ExtResource("1_nf5k1")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]

```

### 📄 `Utility\CustomType\CPolygon2D.gd`

```gdscript
# It is custome class build for automatic build collission block base on a Polygon2D
class_name CPolygon2D
extends Polygon2D

func setBodyFromPolygon(poly: PackedVector2Array = []) -> void:
	var body = StaticBody2D.new()
	var collision_shape = CollisionPolygon2D.new()
	if poly.size() != 0:
		collision_shape.polygon = poly
	else:
		collision_shape.polygon = polygon
	body.add_child(collision_shape)
	add_child(body)

```

### 📄 `Utility\CustomType\DamageBonusInfo.gd`

```gdscript
extends Resource

#when the card is casted add this value to all direct attack number
@export var flatDirectDmgBonus : float
#when the card is casted add this value to all indirect attack number
@export var flatIndirectDmgBonus : float
#Come last in the calculation of direct damage output, mutl all direct attack number by this coef 
@export var coefDirectDmgBonus : float
#Come last in the calculation of indirect damage output, mutl all indirect attack number by this coef 
@export var coefIndirectDmgBonus : float

```

### 📄 `Utility\CustomType\HealthInfo.gd`

```gdscript
class_name HealthInfo
extends Resource

signal infoChanged()
signal healthChanged(amountChanged : float)
signal healthDropZero()

@export var visibleHpBar : bool = true :
	set(nVisible):
		visibleHpBar = nVisible
		infoChanged.emit()
@export var maxHealth : float = 100 : set = setMaxHealth, get = getMaxHealth
@export var health : float = 0 : set = setHealth, get = getHealth

func heal(nHeal: float) -> void:
	setHealth(health + nHeal)

func takeDamage(damage: float) -> void:
	setHealth(health - damage)

func setHealth(nHealth: float) -> void:
	var bufferHealth = health
	health = clampf(nHealth, 0, maxHealth)
	if bufferHealth != health:
		infoChanged.emit()
		if health == 0:
			healthDropZero.emit()
		else:
			healthChanged.emit(health - bufferHealth)
	
func getHealth() -> float:
	return health

func setMaxHealth(nMaxHealth: float) -> void:
	var diffHealth : float = nMaxHealth - maxHealth
	maxHealth = nMaxHealth
	infoChanged.emit()
	
func getMaxHealth() -> float:
	return maxHealth

```

### 📄 `Utility\CustomType\MovementBody2D.gd`

```gdscript
class_name MovementBody2D
extends CharacterBody2D

@export var speed : float = 1500 : set = setSpeed, get = getSpeed
@export var acceleration : float = 7500 : set = setAcceleration, get = getAcceleration
@export var deceleration : float = 10000
@export var uTurnAccel : float = 4
@export var steeringAccel : float = 3
@export_range(0, 1) var inertia : float = 0.1 : set = setInertia, get = getInertia

@onready var dir : Vector2 : set = setDir, get = getDir 
@onready var energy : Vector2 : set = setEnergy, get = getEnergy
@onready var dirLock := false

func resetEnergy(gradiant : Vector2 = Vector2.ZERO) -> void:
	setEnergy(energy * gradiant)

func _physics_process(delta: float) -> void:
	updateDir()
	updateEnergy(delta)
	set_velocity(energy)
	move_and_slide()

func updateDir() -> void:
	pass

func updateEnergy(delta: float):
	if dir == Vector2.ZERO:
		setEnergy(energy.move_toward(Vector2.ZERO, deceleration * (1 - inertia) * delta))
	else:
		var turningAngle : float  = energy.dot(dir)
		var tmpAccel : float = acceleration
		if turningAngle < 0 :
			tmpAccel *= uTurnAccel
		elif turningAngle < 0.85 :
			tmpAccel *= steeringAccel
		var finaLAccel = tmpAccel * (1 - inertia)
		setEnergy(energy.move_toward(dir * speed, finaLAccel * delta))

func lockDir(nLock: bool) -> MovementBody2D:
	dirLock = nLock
	return self	

### all getter | setter ###
func setAcceleration(nAcceleration: float) -> MovementBody2D:
	acceleration = nAcceleration
	return self

func getAcceleration() -> float:
	return acceleration
	
func addAcceleration(aAcceleration: float) -> MovementBody2D:
	setAcceleration(acceleration + aAcceleration)
	return self

func setInertia(nInertia: float) -> MovementBody2D:
	inertia = clampf(nInertia, 0, 1)
	return self

func getInertia() -> float:
	return inertia
	
func addInertia(aInertia: float) -> MovementBody2D:
	setInertia(clampf(inertia + aInertia, 0, 1))
	return self

func setSpeed(nSpeed: float) -> MovementBody2D:
	speed = nSpeed
	if speed < 0:
		speed = 0
	return self
	
func getSpeed() -> float:
	return speed

func addSpeed(nSpeed: float) -> MovementBody2D:
	setSpeed(speed + nSpeed)
	return self

func setDir(nDir: Vector2) -> MovementBody2D:
	if !dirLock:
		dir = nDir.normalized()
	return self
	
func getDir() -> Vector2:
	return dir

func setEnergy(nEnergy: Vector2) -> MovementBody2D:
	energy = nEnergy
	return self
	
func getEnergy() -> Vector2:
	return energy

```

### 📄 `Weapon\Cursor.gd`

```gdscript
class_name Cursor
extends Node2D

@export var color : Color = Color(1,1,1,1)
@export var radius : float = 25 :
	get:
		return radius
	set(nRadius):
		radius = nRadius
@export var distanceToHolder : float = 10

@onready var dir : Vector2 : set = setDir

func _ready():
	queue_redraw()
	
func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func setDir(nDir: Vector2) -> void:
	dir = nDir
	position = dir * distanceToHolder

```

### 📄 `Weapon\Weapon.gd`

```gdscript
class_name Weapon
extends Node2D

signal reloading()
signal reloaded()

const WeaponInfo = preload("res://Weapon/WeaponInfo.gd")

@onready var BacisProjectileScene = preload("res://Cards/Ability/SkillShot/BasicProjectile.tscn")

@export var info : WeaponInfo
@export var holder : Commander

##TODO pour que le HUD ne bouge pas en même temps que le joueur faut avoir top_level = true 

@onready var timerFireRate = %TimerFireRate
@onready var timerReload = %TimerRelooad
@onready var cursor = %Cursor

func _ready() -> void:
	timerFireRate.wait_time = info.fireRate
	timerReload.wait_time = info.speedReload
	timerReload.timeout.connect(reload)

func setDirCursor(nDir: Vector2) -> void:
	cursor.setDir(nDir)

func tryShoot() -> bool:
	if (timerFireRate.time_left == 0 && info.leftInMagazine > 0):
		shootBullet()
		return true
	return false

func reload() -> void:
	info.leftInMagazine = info.sizeMagazine
	reloaded.emit()
		
func shootBullet() -> void:
	info.leftInMagazine -= 1
	if info.leftInMagazine == 0:
		reloading.emit()
		timerReload.start()
	var bullet := BacisProjectileScene.instantiate()
	bullet.dir = cursor.dir
	bullet.setSpeed(info.speedBullet)
	bullet.position = cursor.global_position
	holder.add_child(bullet)
	timerFireRate.start()

```

### 📄 `Weapon\Weapon.tscn`

```ini
[gd_scene load_steps=5 format=3 uid="uid://d4ffh65mxnhar"]

[ext_resource type="Script" uid="uid://c1s2odagh5qot" path="res://Weapon/Weapon.gd" id="1_fwiay"]
[ext_resource type="Script" uid="uid://bykif5peqeubt" path="res://Weapon/WeaponInfo.gd" id="2_370bg"]
[ext_resource type="Script" uid="uid://cgdc40mbyvcgy" path="res://Weapon/Cursor.gd" id="3_l4m4n"]

[sub_resource type="Resource" id="Resource_l4m4n"]
script = ExtResource("2_370bg")
fireRate = 0.2
speedBullet = 3000.0
sizeBullet = 30.0
sizeMagazine = 8.0
leftInMagazine = null
speedReload = 2.0
metadata/_custom_type_script = "uid://bykif5peqeubt"

[node name="Weapon" type="Node2D"]
top_level = true
script = ExtResource("1_fwiay")
info = SubResource("Resource_l4m4n")

[node name="TimerFireRate" type="Timer" parent="."]
unique_name_in_owner = true
one_shot = true

[node name="TimerRelooad" type="Timer" parent="."]
unique_name_in_owner = true
one_shot = true

[node name="WeaponHud" type="Control" parent="TimerRelooad"]
layout_mode = 3
anchors_preset = 3
anchor_left = 1.0
anchor_top = 1.0
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = -170.0
offset_top = -89.0
grow_horizontal = 0
grow_vertical = 0

[node name="RichTextLabel" type="RichTextLabel" parent="TimerRelooad/WeaponHud"]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -94.0
offset_top = -46.5
offset_right = 94.0
offset_bottom = 46.5
grow_horizontal = 2
grow_vertical = 2
bbcode_enabled = true
text = "8/8
"

[node name="Cursor" type="Node2D" parent="."]
unique_name_in_owner = true
script = ExtResource("3_l4m4n")
metadata/_custom_type_script = "uid://cgdc40mbyvcgy"

```

### 📄 `Weapon\WeaponEnum.gd`

```gdscript
extends Object

enum Mode {
	AUTOMATIC,
	SEMI_AUTOMATIC,
	MANUAL
}

```

### 📄 `Weapon\WeaponInfo.gd`

```gdscript
extends Resource

const WeaponEnum = preload("res://Weapon/WeaponEnum.gd")

@export_category("Stat weapong")
@export var fireRate : float = 0.2
@export var speedBullet : float = 3000
@export var sizeBullet : float = 30
@export var sizeMagazine : float = 8
@export var leftInMagazine : float = sizeMagazine
@export var speedReload : float = 0.1

```

