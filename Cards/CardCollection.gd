class_name CardCollection
extends Node

var collection : Dictionary[int, CardInfo] = {
	0: CardInfo.new("Ida's Wind", "0.5/1", "Spell - Attack", "SkillShot 10/300"),
	1: CardInfo.new("Wind rises", "0.5/-1", "Spell - Movement", "Dash 3000/0.15 | Gain 1CWind")
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
	#collection[0] = CardInfo.new("Ida's Wind", "2/1", "Spell - Attack", "Gain 1CWind")
	## | SkillShot 2*X(CWind)")
	#collection[1] = CardInfo.new("Wind rises", "5/-1", "Spell - Movement", "Dash 3000/0.2")
	## | AfterDash TmpGain 250/1 MS")
	print("Collection has finished")
