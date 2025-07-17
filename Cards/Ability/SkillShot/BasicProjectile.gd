class_name BacicProjectile
extends Node2D 

@export var color : Color = Color(0,0,1,1)
@export var radius : float = 30 :
	get:
		return radius
	set(nRadius):
		collisionshape.shape.radius = nRadius
		radius = nRadius
@export var speed : float = 3000

@onready var dir : Vector2
@onready var collisionshape : CollisionShape2D

func _ready():
	set_as_top_level(true)
	queue_redraw()
	
func _process(delta: float) -> void:
	position += speed * dir * delta
	
func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func hit(collsionEntity: Area2D) -> void:
	queue_free()
