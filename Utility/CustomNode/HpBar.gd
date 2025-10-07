class_name HpBar
extends MarginContainer

@onready var hpBar : ProgressBar

func _ready() -> void:
	hpBar = $HpBar

func updateHpBarNode(info: HealthInfo) -> void:
	if info != null:
		if (hpBar.visible != info.visibleHpBar):
			hpBar.visible = info.visibleHpBar
		if (hpBar.max_value != info.maxHealth):
			hpBar.max_value = info.maxHealth
		if (hpBar.value != info.health):
			hpBar.set_value(info.health)
