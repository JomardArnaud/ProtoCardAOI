class_name Hitbox2D
extends Area2D

signal triggerArea(area)

func _on_area_entered(area: Area2D) -> void:
	emit_signal("triggerArea", area)
	owner.queue_free()

func _on_body_entered(body: Node2D) -> void:
	owner.queue_free()
