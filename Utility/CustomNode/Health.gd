class_name Health
extends Control

signal healthChanged(nHealth: int)
signal healthDropZero(selfInfo : HealthInfo)

@export var info : HealthInfo
@export var hpBar : HpBar

func _ready() -> void:
	if (hpBar == null):
		hpBar = $HpBar
	else:
		$HpBar.queue_free()
	if (info == null):
		push_error("no health info found")
		return
	info.infoChanged.connect(hpBar.updateHpBarNode.bind(info))
	info.healthDropZero.connect(onHealthDropZero)
	hpBar.updateHpBarNode(info)	
	
func onHealthDropZero() -> void:
	healthDropZero.emit(info)

func _on_hurt_box_take_hit(damage: float) -> void:
	info.takeDamage(damage) # Replace with function body.
