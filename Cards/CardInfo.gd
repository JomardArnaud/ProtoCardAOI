class_name CardInfo
extends Resource

@export var name: String
@export var cost: String
@export var type: String
@export var subType: String
@export var description: String
	
func _init(nName="", nCost="", nType="", nDescription=""):
	name = nName
	cost = nCost
	type = nType
	subType = getSubType()
	description = nDescription

func getSubType() -> String:
	var typeSplit = type.split(" - ")
	if (typeSplit.size() > 1):
		return typeSplit[1]
	return ""
