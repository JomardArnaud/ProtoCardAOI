class_name Hitbox2D
extends Area2D

@onready var collisionShape := %CollisionShape2D

func _ready() -> void:
	add_to_group("targetable", false)
	if collisionShape == null:
		push_error("This hitbox doesn't have a CollisionShape2D")

func getCollisionShape() -> CollisionShape2D:
	return collisionShape

func _input_event(viewport, event, shape_idx):
	pass
