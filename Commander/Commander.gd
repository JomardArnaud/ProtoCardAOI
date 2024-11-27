class_name Commander
extends Node2D

@export var commanderInfo : CommanderInfo

@onready var hp : Health = %Health

func _ready() -> void:
	print("commander ready func")
	if (commanderInfo.health != null):
		hp.setNodeInfo(commanderInfo.health)
