class_name CardAbility
extends Node

var caster : PlayerController
var description : String

func _init(nCaster: PlayerController, nDescription: String) -> void:
	caster = nCaster
	description = nDescription

func resolve() -> void:
	pass

func init() -> void:
	pass
