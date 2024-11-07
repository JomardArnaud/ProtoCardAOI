class_name Health
extends Control

@export var info : HealthInfo

@onready var hpBar := $HpBar

func _ready() -> void:
	self.visible = info.visibleHpBar
	hpBar.value = info.health
	var parent = get_parent()
	info.healthChanged.connect(onHealthChanged)
	if (parent.has_method("onHealthChanged")):
		info.healthChanged.connect(parent.onHealthChanged.bind())
	if (parent.has_method("onHealthDropZero")):
		info.healthDropZero.connect(parent.onHealthDropZero.bind())
	
func onHealthChanged(nHP: float) -> void:
	hpBar.value = nHP
