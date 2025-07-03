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

func _ready():
	queue_redraw()
	
func _input(event: InputEvent) -> void:
	position = Vector2.ZERO
	if Input.get_connected_joypads().has(playerId):
		var horizontalDirection = Input.get_joy_axis(playerId, JOY_AXIS_RIGHT_X)
		var verticalDirection = Input.get_joy_axis(playerId, JOY_AXIS_RIGHT_Y)
		if (Vector2(horizontalDirection, verticalDirection).length() > 0.2):
			position = Vector2(horizontalDirection, verticalDirection).normalized() * distanceToHolder

func _draw():
	draw_circle(Vector2.ZERO, radius, color)
