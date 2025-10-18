class_name PlayerController
extends MovementBody2D

@export var playerId = 0

## TODO Not using InputMaganger here
var horizontalDirection : float
var verticalDirection : float

func updateDir() -> void:
	setDir(Vector2.ZERO)
	if Input.get_connected_joypads().has(playerId):
		horizontalDirection = Input.get_joy_axis(playerId, JOY_AXIS_LEFT_X)
		verticalDirection = Input.get_joy_axis(playerId, JOY_AXIS_LEFT_Y)
		if (Vector2(horizontalDirection, verticalDirection).length() > 0.2):
			setDir(Vector2(horizontalDirection, verticalDirection))
	else:
		horizontalDirection = int(Input.is_action_pressed("moveLeft")) * -1 + int(Input.is_action_pressed("moveRight"))
		verticalDirection = int(Input.is_action_pressed("moveUp")) * -1 + int(Input.is_action_pressed("moveDown"))
		setDir(Vector2(horizontalDirection, verticalDirection))
		
func getDirDash() -> Vector2:
	return dir
	
func getDirAttack() -> Vector2:
	return InputManager.get_instance().getDirAttack(self)
