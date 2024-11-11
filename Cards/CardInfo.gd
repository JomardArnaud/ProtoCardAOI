class_name CardInfo
extends Resource

@export var name: String
@export var cost: String
@export var type: CardType
@export var description: String

enum CardType {
	SPELL,
	PERMANANT
}

func _init(nName="", nCost="", nType=CardType.SPELL, nDescription=""):
	name = nName
	cost = nCost
	type = nType
	description = nDescription
