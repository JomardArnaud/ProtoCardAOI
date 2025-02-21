class_name CardInfo
extends Resource

const CardEnum = preload("res://Cards/CardEnum.gd")

@export var name: String
@export var cost: String
@export var type: String
@export var subType: String
@export var description: String

func _ready():
	print(CardEnum.CardZone.Deck) 
	
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
