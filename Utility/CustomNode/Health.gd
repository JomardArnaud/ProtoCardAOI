class_name Health
extends Control

@export var info : HealthInfo : set = setNodeInfo

var hoBarReady := false
@onready var hpBar : ProgressBar = %HpBar

func _ready() -> void:
	if info == null:
		return
	updateNodeInfo()

func setNodeInfo(nInfo: HealthInfo) -> void:
	if (nInfo != null && info != nInfo):
		info = nInfo
		updateNodeInfo()

func updateNodeInfo() -> void:
	self.visible = info.visibleHpBar
	if (hpBar == null):
		hpBar = %HpBar
	if (hoBarReady == true) :
		hpBar.set_value(info.health)
		var parent = get_parent()
		info.healthChanged.connect(onHealthChanged)
		if (parent.has_method("onHealthChanged")):
			info.healthChanged.connect(parent.onHealthChanged.bind())
		if (parent.has_method("onHealthDropZero")):
			info.healthDropZero.connect(parent.onHealthDropZero.bind())

func onHealthChanged(nHP: float) -> void:
	hpBar.value = nHP

func _on_hp_bar_ready():
	hoBarReady = true
