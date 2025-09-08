class_name Slot
extends TextureRect

@export var typeSlot : String = "DASH"

func _ready() -> void:
	%LabelType.text =  "[center]" + typeSlot + "[center]"
