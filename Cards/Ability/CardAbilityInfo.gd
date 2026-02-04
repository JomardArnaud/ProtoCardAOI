class_name CardAbilityInfo
extends Resource

const PATH_ABILITY = "res://Cards/Ability/"

@export var abilityName: String 
@export var abilityScript : GDScript
@export var param : Dictionary

func _init(nName: String = "", nParam: Dictionary = {}) -> void:
	if nName == "":
		push_error("Ability need name")
		return
	abilityName = nName
	var pathAbility = PATH_ABILITY + abilityName + ".gd"
	if ResourceLoader.exists(pathAbility):
		abilityScript = load(pathAbility)
	else:
		push_error("Ability not found, path :" + pathAbility + "don't exist")
	param = nParam
