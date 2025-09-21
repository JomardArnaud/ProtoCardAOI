class_name HpBar
extends MarginContainer

@onready var hpBar = %HpBar

func _ready() -> void:
	pivot_offset = size / 2

func updateHpBarNode(info: HealthInfo) -> void:
	if info != null:
		if (hpBar.visible != info.visibleHpBar):
			hpBar.visible = info.visibleHpBar
		if (hpBar.value != info.health):
			hpBar.set_value(info.health)
		if (hpBar.max_value != info.maxHealth):
			hpBar.max_value = info.maxHealth

func _on_health_health_changed(delta: int) -> void:
	
	pass

func _on_health_health_drop_zero(infoHp: HealthInfo) -> void:
	pass # Replace with function body.
