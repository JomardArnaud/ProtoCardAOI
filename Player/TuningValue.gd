class_name TurnerPanel
extends PanelContainer

@export var toggleKey : Key = KEY_TAB

func _ready() -> void:
	set_process_unhandled_input(true)
	hide()
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		
		if event.keycode == toggleKey:
			toggleTuner()

func toggleTuner() -> void:
	visible = !visible
	get_tree().paused = visible
	pass
