class_name HpBar
extends MarginContainer

@onready var hpBar = %HpBar

func updateHpBarNode(info: HealthInfo) -> void:
	if info != null:
		pass
		if (hpBar.visible != info.visibleHpBar):
			hpBar.visible = info.visibleHpBar
		if (hpBar.value != info.health):
			hpBar.set_value(info.health)
		if (hpBar.max_value != info.maxHealth):
			hpBar.max_value = info.maxHealth
	pass
