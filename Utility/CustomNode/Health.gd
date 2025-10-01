class_name Health
extends Control

signal healthChanged(nHealth: int)
signal healthDropZero(selfInfo : HealthInfo)

@export var info : HealthInfo

@onready var hpBar : HpBar

func _ready() -> void:
	hpBar = %HpBar
	if (info == null):
		push_error("no health info found")
		return
	hpBar.updateHpBarNode(info)	
	info.infoChanged.connect(hpBar.updateHpBarNode.bind(info))
	info.healthDropZero.connect(onHealthDropZero)

func onHealthDropZero() -> void:
	healthDropZero.emit(info)

func _on_hurt_box_take_hit(damage: float) -> void:
	info.takeDamage(damage) # Replace with function body.
