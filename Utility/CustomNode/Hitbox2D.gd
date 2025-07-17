class_name Hitbox2D
extends Area2D

@onready var hit : Callable

func _ready() -> void:
	var parent = get_parent()
	if (parent.has_method("hit")):
		hit = get_parent().hit

func _on_area_entered(area: Area2D) -> void:
	if (!hit.is_null()):
		hit.call(area)

func _on_body_entered(body: Node2D) -> void:
	if (!hit.is_null()):
		hit.call(body)
