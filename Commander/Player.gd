class_name PlayerController
extends MovementBody2D

@onready var commanderNode : Commander = $Commander

var horizontalDirection : float
var verticalDirection : float
func updateDir() -> void:
	setDir(Vector2.ZERO)
	horizontalDirection = int(Input.is_action_pressed("moveLeft")) * -1 + int(Input.is_action_pressed("moveRight"))
	verticalDirection = int(Input.is_action_pressed("moveUp")) * -1 + int(Input.is_action_pressed("moveDown"))
	setDir(Vector2(horizontalDirection, verticalDirection))
		
func getDirDash() -> Vector2:
	return InputManager.get_instance().getDirDash(self)
	
func getDirAttack() -> Vector2:
	return InputManager.get_instance().getDirAttack(self)

func _input(event: InputEvent) -> void:
	for i in range(1, 7):
		if event.is_action_released("Cast" + str(i)):
			commanderNode.castHandCard(i - 1)
		pass
	pass
