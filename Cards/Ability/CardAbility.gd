class_name CardAbility
extends Node

var caster : Commander
var description : String

func _init(nCaster: Commander, nDescription: String) -> void:
	caster = nCaster
	description = nDescription

func resolve() -> void:
	pass

func init() -> void:
	pass
