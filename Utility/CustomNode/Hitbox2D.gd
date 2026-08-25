class_name Hitbox2D
extends Area2D

signal triggerArea(area)
signal triggerBody(body)

func _on_area_entered(area: Area2D) -> void:
	triggerArea.emit(area)
	
func _on_body_entered(body: Node2D) -> void:
	triggerBody.emit(body)
