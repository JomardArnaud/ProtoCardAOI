class_name Health
extends Control

const HealthInfo = preload("res://Utility/CustomType/HealthInfo.gd")

signal healthChanged(nHealth: int)
signal healthDropZero(infoHp : HealthInfo)

@export var info : HealthInfo

@onready var hpBar : HpBar

func _ready() -> void:
	hpBar = %HpBar
	setHpBarNode()

func setHpBarNode() -> void:
	if (info == null):
		push_error("no health info found")
		return
	hpBar.updateHpBarNode(info)
	info.healthChanged.connect(onHealthChanged)
	info.healthDropZero.connect(onHealthDropZero)

func onHealthChanged(nHP: int) -> void:
	hpBar.hpBar.value = nHP

func onHealthDropZero(nInfo: HealthInfo) -> void:
	healthDropZero.emit(nInfo)

func _on_hurt_box_take_hit(damage: float) -> void:
	info.takeDamage(damage) # Replace with function body.
