class_name Cursor
extends Node2D

@export var color : Color = Color(1,1,1,1)
@export var radius : float = 25 :
	get:
		return radius
	set(nRadius):
		radius = nRadius
@export var distanceToHolder : float = 10

@onready var playerId : int = 0
@onready var pos : Vector2
@onready var dir : Vector2

func _ready():
	var playerId = get_parent().playerId
	queue_redraw()
	
func _process(_delta: float) -> void:
	dir = Vector2.ZERO
	position = Vector2.ZERO
	dir = InputManager.get_instance().getAimAttack(get_tree().get_nodes_in_group("Players")[playerId])
	position = dir * distanceToHolder

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
