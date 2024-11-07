class_name PlayerController
extends MovementBody2D

func updateDir() -> void:
	var horizontalDirection = int(Input.is_action_pressed("moveLeft")) * -1 + int(Input.is_action_pressed("moveRight"))
	var verticalDirection = int(Input.is_action_pressed("moveUp")) * -1 + int(Input.is_action_pressed("moveDown"))
	setDir(Vector2(horizontalDirection, verticalDirection))
