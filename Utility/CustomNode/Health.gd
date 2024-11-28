class_name Health
extends Control

@export var info : HealthInfo

@onready var hpBar : ProgressBar

func setNodeInfo(nInfo: HealthInfo) -> void:
	info = nInfo
	updateHpBarNode()
		
func setHpBarNode() -> void:
	var parent = get_parent()
	if (parent is Commander && info == null):
		info = parent.commanderInfo.health
	else:
		updateHpBarNode()
	info.healthChanged.connect(onHealthChanged)
	if (parent.has_method("onHealthChanged")):
		info.healthChanged.connect(parent.onHealthChanged.bind())
	if (parent.has_method("onHealthDropZero")):
		info.healthDropZero.connect(parent.onHealthDropZero.bind())

func updateHpBarNode() -> void:
	if (hpBar.visible != info.visibleHpBar):
		hpBar.visible = info.visibleHpBar
	if (hpBar.value != info.health):
		hpBar.set_value(info.health)
	if (hpBar.max_value != info.maxHealth):
		hpBar.max_value = info.maxHealth

func onHealthChanged(nHP: float) -> void:
	hpBar.value = nHP

func _on_hp_bar_ready():
	hpBar = %HpBar
	setHpBarNode()
