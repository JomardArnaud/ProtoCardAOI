class_name BacicProjectile
extends MovementBody2D

@export var color : Color = Color(0,0,1,1)
@export var radius : float = 30 :
	get:
		return radius
	set(nRadius):
		radius = nRadius

func _ready():
	set_as_top_level(true)
	setSpeed(2750)
	acceleration = 1000
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
