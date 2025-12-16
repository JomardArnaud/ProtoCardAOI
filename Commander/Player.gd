class_name PlayerController
extends MovementBody2D

## TODO Not using InputMaganger here
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
	if event.is_action_pressed()
	pass
