class_name CardInfo
extends Resource

@export var name: String
@export var cost: String
@export var type: String
@export var description: String
 
enum CardZone {
	Deck,
	SpellHand,
	PermanantHand,
	Graveyard,
	Exile
}

enum CardType {
	SPELL,
	PERMANENT
}

func _init(nName="", nCost="", nType="", nDescription=""):
	name = nName
	cost = nCost
	type = nType
	description = nDescription
