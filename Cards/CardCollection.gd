class_name CardCollection
extends Node

const CardEnum = preload("res://Cards/CardEnum.gd")
const CardInfo = preload("res://Cards/CardInfo.gd")

var collection : Dictionary[int, CardInfo] = {
	0: CardInfo.new("Ida's Wind", 0, CardEnum.CardType.ATTACK, "SkillShot 10/300"),
	1: CardInfo.new("Wind rises", 0, CardEnum.CardType.DASH, "Dash 3000/0.15 | Gain 1CWind"),
	2: CardInfo.new("Blank Attack", 0, CardEnum.CardType.ATTACK, "Blank"),
	3: CardInfo.new("Blank Dash", 0, CardEnum.CardType.DASH, "Blank"),
	4: CardInfo.new("Blank Spell", 0, CardEnum.CardType.SPELL, "Blank")
} : get = getCollection

func _init() -> void:
	fillCollection()

func getCollection():
	return collection

func getCardById(idCard: int):
	if idCard > collection.size():
		idCard = 0
		printerr("idCard isn't in the scope")	
	return collection[idCard]
	
func fillCollection():
	print("Waiting collection to finishing collecting ...")
	print("Collection has finished")
