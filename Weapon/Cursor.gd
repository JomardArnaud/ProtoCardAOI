class_name Cursor
extends Node2D

@export var color : Color = Color(1,1,1,1)
@export var radius : float = 2 :
	get:
		return radius
	set(nRadius):
		radius = nRadius
@export var distanceToHolder : float = 10

@onready var dir : Vector2 : set = setDir

func _ready():
	queue_redraw()
	
func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func setDir(nDir: Vector2) -> void:
	dir = nDir
	position = dir * distanceToHolder
