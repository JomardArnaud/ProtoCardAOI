class_name PlayerController
extends MovementBody2D

const CardEnum = preload("res://Cards/CardEnum.gd")

@onready var commander : Commander = $Commander
@onready var weapon : Weapon = $Weapon

var horizontalDirection : float
var verticalDirection : float

func _ready() -> void:
	if commander != null && weapon != null:
		commander.getDirAttack = getDirAttack
		commander.getDirDash = getDirDash
		commander.setWeapon(weapon)
		weapon.holder = commander

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
	## TODO remove it for release
	if Input.is_action_just_pressed("ExitGame"):
		get_tree().quit()
