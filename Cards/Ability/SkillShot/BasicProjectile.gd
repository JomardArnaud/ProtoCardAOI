class_name BacicProjectile
extends MovementBody2D

@export var color : Color = Color(1,0,0,1)
@export var radius : float = 12 :
	get:
		return radius
	set(nRadius):
		radius = nRadius

func _ready():
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
