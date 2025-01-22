class_name PlayerController
extends MovementBody2D

func updateDir() -> void:
	if Input.get_connected_joypads().has(0):
		var horizontalDirection = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
		var verticalDirection = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		if (Vector2(horizontalDirection, verticalDirection).length() > 0.2):
			setDir(Vector2(horizontalDirection, verticalDirection))
		else:
			setDir(Vector2.ZERO)
	else:
		setDir(Vector2.ZERO)
	#var horizontalDirection = int(Input.is_action_pressed("moveLeft")) * -1 + int(Input.is_action_pressed("moveRight"))
	#var verticalDirection = int(Input.is_action_pressed("moveUp")) * -1 + int(Input.is_action_pressed("moveDown"))
