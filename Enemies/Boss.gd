class_name Boss
extends MovementBody2D

@export var distanceToGet : float 
@export var player : PlayerController

@onready var hurtBox : Hurtbox2D = $HurtBox
@onready var mainSprite : Sprite2D = $MainSprite

var distanceToPlayer : float

func setPlayerInfo() -> void:
	pass

func _ready() -> void:
	hurtBox.takeHit.connect(onHit)

func _process(_delta: float) -> void:
	setPlayerInfo()

func onHit(_damage : float, _source: Node2D):
	mainSprite.modulate = Color(3, 3, 3)
	create_tween().tween_property(mainSprite, "modulate", Color.WHITE, 0.1)
