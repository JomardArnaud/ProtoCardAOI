class_name Boss
extends MovementBody2D

@export var distanceToGet : float 
@export var player : PlayerController

var distanceToPlayer : float

func setPlayerInfo() -> void:
	pass

func _ready() -> void:
	set_physics_process(false)

func _process(_delta: float) -> void:
	setPlayerInfo()
