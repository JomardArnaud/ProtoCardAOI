class_name Hurtbox2D
extends Area2D

@onready var getHurt : Callable

func _ready() -> void:
	var parent = get_parent()
	if (parent.has_method("getHurt")):
		getHurt = get_parent().getHurt

func _on_area_entered(area: Area2D) -> void:
	if (!getHurt.is_null()):
		getHurt.call(area)
	else:
		push_error("Hurtbox need a getHurt function")
