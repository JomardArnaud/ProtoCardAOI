class_name BasicProjectile
extends Node2D 

@export var color : Color = Color(0,0,1,1)
@export var radius : float = 30 : set = setRadius
@export var speed : float = 3000.0
@export var maxRange : float = 3000.0
@export var damage : float = 10.0 :
	set(nDamage): damage = nDamage
	
@onready var collisionshape : CircleShape2D = $Hitbox/CollisionShape2D.shape
@onready var hitbox : Hitbox2D = $Hitbox
@onready var raycast : RayCast2D = $RayCast2D

var dir : Vector2
var travelledDistance : float = 0.0

func _ready():
	set_as_top_level(true)
	queue_redraw()
	hitbox.triggerArea.connect(hit)
	hitbox.triggerBody.connect(vanish)
	setRadius(radius)
	
func _physics_process(delta: float) -> void:
	raycast.target_position = dir * (speed * delta + 5.0)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var impact_point := raycast.get_collision_point()
		global_position = impact_point
		vanish(raycast.get_collider())
		return
	var step = speed * delta	
	global_position += dir * step
	travelledDistance += step
	if travelledDistance >= maxRange:
		queue_free()
	
func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func hit(collsionEntity: Node2D) -> void:
	collsionEntity.takeHit.emit(damage)
	vanish(collsionEntity)
	
func vanish(_collsionEntity: Node2D) -> void:
	call_deferred("queue_free")

func setRadius(nRadius: float) -> void:
	radius = nRadius
	if (collisionshape != null):
		collisionshape.set_radius(nRadius)

func setDir(nDir: Vector2) -> void:
	dir = nDir

func setSpeed(nSpeed: float) -> void:
	speed = nSpeed
