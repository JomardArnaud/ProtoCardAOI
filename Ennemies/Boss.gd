class_name Boss
extends MovementBody2D

@export var distanceToGet : float 
@export var player : PlayerController

var distanceToPlayer : float

func setPlayerInfo() -> void:
	pass

func _process(delta: float) -> void:
	setPlayerInfo()
	
	pass
