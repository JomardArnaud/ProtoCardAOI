class_name Health
extends Control

signal healthChanged()
signal healthDropZero(infoHp : HealthInfo)

@export var info : HealthInfo

@onready var hpBar : HpBar

func setHpBarNode() -> void:
	if (info == null):
		push_error("no health info found")
		return
	hpBar.updateHpBarNode(info)
	info.healthChanged.connect(onHealthChanged)
	info.healthDropZero.connect(onHealthDropZero)

func onHealthChanged(nHP: float) -> void:
	hpBar.hpBar.value = nHP

func onHealthDropZero() -> void:
	healthDropZero.emit(info)

func _on_hp_bar_ready():
	hpBar = %HpBar
	setHpBarNode()

func _on_hurt_box_take_hit(damage: float) -> void:
	info.takeDamage(damage) # Replace with function body.
