class_name CardAbilityInfo
extends Resource

const PATH_ABILITY = "res://Cards/Ability/"

@export var abilityName: String 
@export var abiltyScript : GDScript
@export var param : Dictionary

func _init(nName: String = "", nParam: Dictionary = {}) -> void:
	if nName == "":
		push_error("Ability need name")
		return
	abilityName = nName
	var pathAbility = PATH_ABILITY + abilityName + ".gd"
	if ResourceLoader.exists(pathAbility):
		abiltyScript = load(pathAbility)
	else:
		push_error("Ability not found, path :" + pathAbility + "don't exist")
	param = nParam

func createNode() -> CardAbilityNode:
	if abiltyScript == null:
		push_error("No script loaded for ability: " + abilityName)
		return CardAbilityNode.new()
	var nAbility : CardAbilityNode = abiltyScript.new()
	nAbility.setupParam(param)
	return nAbility
