class_name Scarecrow
extends Node2D

@export var cdRespawn : int = 1
@onready var hurtBox2D : Hurtbox2D = $HurtBox

func _on_health_health_drop_zero(infoHp: HealthInfo) -> void:
	visible = false
	hurtBox2D.set_deferred("monitorable", false)
	await get_tree().create_timer(cdRespawn).timeout
	visible = true
	hurtBox2D.set_deferred("monitorable", true)
	infoHp.heal(infoHp.maxHealth)
