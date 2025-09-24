class_name Scracrow
extends Node2D

@export var cdRespawn : int = 1

func _on_health_health_drop_zero(infoHp: Resource) -> void:
	visible = false
	await get_tree().create_timer(cdRespawn).timeout
	visible = true
	infoHp.heal(infoHp.maxHealth)
