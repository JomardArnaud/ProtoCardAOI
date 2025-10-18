class_name Cursor
extends Node2D

@export var color : Color = Color(1,1,1,1)
@export var radius : float = 25 :
	get:
		return radius
	set(nRadius):
		radius = nRadius
@export var distanceToHolder : float = 10

@onready var pos : Vector2
@onready var dir : Vector2

func _ready():
	if (!get_parent().has_method("getDirAttack")):
		push_error("Crusor's patents isn't valid (don't has method getDirAttack)")
	queue_redraw()
	
func _process(_delta: float) -> void:
	dir = Vector2.ZERO
	dir = get_parent().getDirAttack()
	position = dir * distanceToHolder

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
