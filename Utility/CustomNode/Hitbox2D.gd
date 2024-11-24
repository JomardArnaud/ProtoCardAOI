class_name Hitbox2D
extends Area2D

@onready var collisionShape := %CollisionShape2D

func _ready() -> void:
	add_to_group("targetable", false)
	if collisionShape == null:
		push_error("This hitbox doesn't have a CollisionShape2D")


func _on_mouse_entered():
	pass # Replace with function body.


func _on_mouse_shape_entered(shape_idx):
	print(shape_idx)  
	pass # Replace with function body.
