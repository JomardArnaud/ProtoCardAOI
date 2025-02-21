extends CardAbility

signal Dash()

@onready var caster : Commander
@onready var holder : MovementBody2D
@onready var cdTimer : float
@onready var durationTimer : Timer

func resolve() -> void:
	pass

func setupParsing(nCaster: Commander, description: String) -> void:
	
	pass
