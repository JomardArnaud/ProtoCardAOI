class_name Health
extends Control

signal healthChanged
signal healthDropZero(infoHp : HealthInfo)

@export var info : HealthInfo

@onready var hpBar : ProgressBar

func setNodeInfo(nInfo: HealthInfo) -> void:
	info = nInfo
	info.healthChanged.connect(Callable())
	updateHpBarNode()
		
func setHpBarNode() -> void:
	var parent = get_parent()
	if (parent is Commander && info == null):
		info = parent.commanderInfo.health
	updateHpBarNode()
	info.healthChanged.connect(onHealthChanged)
	info.healthDropZero.connect(onHealthDropZero)

func updateHpBarNode() -> void:
	if (hpBar.visible != info.visibleHpBar):
		hpBar.visible = info.visibleHpBar
	if (hpBar.value != info.health):
		hpBar.set_value(info.health)
	if (hpBar.max_value != info.maxHealth):
		hpBar.max_value = info.maxHealth

func onHealthChanged(nHP: float) -> void:
	hpBar.value = nHP

func onHealthDropZero() -> void:
	healthDropZero.emit(info)

func _on_hp_bar_ready():
	hpBar = %HpBar
	setHpBarNode()

func _on_hurt_box_take_hit(damage: float) -> void:
	info.takeDamage(damage) # Replace with function body.
