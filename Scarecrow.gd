extends Node2D

func _on_hitbox_shape_mouse_shape_entered(_shape_idx):
	print(_shape_idx, "is entering")
	MouseManager.setMode(MouseManager.mouseMode.ON_TARGET)

func _on_hitbox_shape_mouse_shape_exited(_shape_idx):
	MouseManager.setMode(MouseManager.mouseMode.BASE)
	print(_shape_idx, "has exited")
