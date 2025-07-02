extends Node2D

@export var color : Color = Color(1,1,1,1)
@export var radius : float = 25 :
	get:
		return radius
	set(nRadius):
		radius = nRadius
		
func _ready():
	queue_redraw()
	
func _draw():
	draw_circle(Vector2(0, 0), radius, color)
