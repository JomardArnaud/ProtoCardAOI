class_name Hitbox2D
extends Area2D

var hit : Callable

func _ready() -> void:
	if (owner.has_method("hit")):
		hit = owner.hit
	else:
		push_error("Hitbox2D: Le owner " + owner.name + " doit avoir une fonction hit()")

func _on_area_entered(area: Area2D) -> void:
	if (hit.is_valid()):
		hit.call(area)
	else:
		push_error("Hitobx need a hit function")
	owner.queue_free()

func _on_body_entered(body: Node2D) -> void:
	owner.queue_free()
