class_name BacicProjectile
extends Node2D 

@export var color : Color = Color(0,0,1,1)
@export var radius : float = 30 : set = setRadius
@export var speed : float = 3000
@export var damage : float = 10 :
	set(nDamage): damage = nDamage
@onready var dir : Vector2
@onready var collisionshape : CircleShape2D

func _ready():
	set_as_top_level(true)
	queue_redraw()
	
func _process(delta: float) -> void:
	position += speed * dir * delta
	
func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func hit(collsionEntity: ) -> void:
	collsionEntity.takeHit.emit(damage)
	
func setRadius(nRadius: float) -> void:
	radius = nRadius
	if (collisionshape != null):
		collisionshape.set_radius(nRadius)

func setDir(nDir: Vector2) -> void:
	dir = nDir

func setSpeed(nSpeed: float) -> void:
	speed = nSpeed

func _on_collision_shape_2d_ready() -> void:
	collisionshape = $HitboxShape/CollisionShape2D.shape
