class_name Hitbox2D
extends Area2D

@onready var collisionShape : Shape2D
@onready var hit : Callable

func _ready() -> void:
	var parent = get_parent()
	if (parent.has_method("hit")):
		hit = get_parent().hit

func _on_area_entered(area: Area2D) -> void:
	hit.call(area)
	pass # Replace with function body.

func _on_collision_shape_2d_ready() -> void:
	collisionShape = $CollisionShape2D.shape 
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	hit.call(body)

func _on_tree_entered() -> void:
	collisionShape = $CollisionShape2D.shape 
	pass # Replace with function body.
