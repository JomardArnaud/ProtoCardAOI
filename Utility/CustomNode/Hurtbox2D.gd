class_name Hurtbox2D
extends Area2D

signal takeHit(damage : float, source: Node2D)

@export var health : Health
@export var active : bool = true

func _ready() -> void:
	if health == null:
		push_warning("%s: Hurtbox2D has no health assigned!" % get_parent().name)

func receiveHit(damage : float, source: Node2D):
	if !active:
		return
	if health != null:
		health.takeDamage(damage)
	takeHit.emit(damage, source)
