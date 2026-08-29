class_name PlayerController
extends MovementBody2D

const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var commander : Commander = $Commander
@onready var weapon : Weapon = $Weapon

var horizontalDirection : float
var verticalDirection : float

@onready var HotkeyPlayer = {
	"MoveUp": InputManager.createKeyEvent(KEY_W),
	"MoveDown": InputManager.createKeyEvent(KEY_S),
	"MoveLeft": InputManager.createKeyEvent(KEY_A),
	"MoveRight": InputManager.createKeyEvent(KEY_D),
	"Shoot": InputManager.createMouseEvent(MOUSE_BUTTON_LEFT),
	"Reload": InputManager.createKeyEvent(KEY_R)
}
@onready var CardSlotHotkey = {
	"CastDASH" : InputManager.createKeyEvent(KEY_SHIFT),
	"CastATTACK" : InputManager.createKeyEvent(KEY_SPACE),
	"CastSPELL" : InputManager.createKeyEvent(KEY_F)
}
@onready var NormalSlotHotkey = {
	"CastSlot0": InputManager.createKeyEvent(KEY_1),
	"CastSlot1": InputManager.createKeyEvent(KEY_2),
	"CastSlot2": InputManager.createKeyEvent(KEY_3),
	"CastSlot3": InputManager.createKeyEvent(KEY_Q),
	"CastSlot4": InputManager.createKeyEvent(KEY_E),
	"CastSlot5": InputManager.createKeyEvent(KEY_4),
	"CastSlot6": InputManager.createKeyEvent(KEY_5)
}
@onready var StartingDeck : Dictionary[int, int] = {
	CardCollection.getCardIdByName("Ida's Wind") : 3,
	CardCollection.getCardIdByName("Wind rises") : 3,
	CardCollection.getCardIdByName("Blank Attack") : 3,
	CardCollection.getCardIdByName("Blank Dash") : 3,
	CardCollection.getCardIdByName("Blank Spell") : 3
}

func _ready() -> void:
	bindindHotkeyFromPlayer()
	if commander != null:
		if weapon != null:
			commander.getDirAttack = getDirAttack
			commander.getDirDash = getDirDash
			commander.setWeapon(weapon)
			weapon.holder = commander
		if commander.deck != null:
			commander.fillDeck(StartingDeck)
		if commander.hand != null:
			commander.hand.setVisibleHotkey(true)
			commander.hand.updateHandHotkeys()
		commander.setupCardEnvironment()

func updateDir() -> void:
	setDir(Vector2.ZERO)
	horizontalDirection = int(Input.is_action_pressed("MoveLeft")) * -1 + int(Input.is_action_pressed("MoveRight"))
	verticalDirection = int(Input.is_action_pressed("MoveUp")) * -1 + int(Input.is_action_pressed("MoveDown"))
	setDir(Vector2(horizontalDirection, verticalDirection))
		
func getDirDash() -> Vector2:
	return InputManager.getDirDash(self)
	
func getDirAttack() -> Vector2:
	return InputManager.getDirAttack(self)

func _process(delta: float) -> void:
	if weapon != null:
		weapon.setDirCursor(getDirAttack())

func _input(event: InputEvent) -> void:
	for nameEvent : String in CardSlotHotkey:
		if event.is_action_released(nameEvent):
			commander.castSlotCard(CardEnum.CardType.get(nameEvent.get_slice("Cast", 1)))
	for hotkey : String in NormalSlotHotkey:
		if event.is_action_released(hotkey):
			commander.castHandCard(hotkey.get_slice("CastSlot", 1).to_int())
	if Input.is_action_pressed("Shoot") && weapon != null:
		weapon.tryShoot()
	## TODO remove it for release
	if Input.is_action_just_pressed("ExitGame"):
		get_tree().quit()

func setupHotkey() -> void:
	var handHotkeyArray: Array[String] = []
	for slotName in NormalSlotHotkey:
		var hotkeyCode = NormalSlotHotkey[slotName]
		if hotkeyCode is Key or hotkeyCode is int:
			handHotkeyArray.append(OS.get_keycode_string(hotkeyCode))
	commander.hand.setHandHotkeys(CardSlotHotkey, handHotkeyArray)
	
func bindindHotkeyFromPlayer() -> void:
	for actionName: String in CardSlotHotkey:
		registerActionInInputMap(actionName, CardSlotHotkey[actionName])
	for actionName: String in NormalSlotHotkey:
		registerActionInInputMap(actionName, NormalSlotHotkey[actionName])
	for actionName: String in HotkeyPlayer:
		registerActionInInputMap(actionName, HotkeyPlayer[actionName])

func registerActionInInputMap(actionName: String, nEvent: InputEvent) -> void:
	if not InputMap.has_action(actionName):
		InputMap.add_action(actionName)
	else:
		InputMap.action_erase_events(actionName)
	if nEvent != null:
		InputMap.action_add_event(actionName, nEvent)
