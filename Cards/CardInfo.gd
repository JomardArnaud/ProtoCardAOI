class_name CardInfo
extends Resource

@export var name: String
@export var cost: String
@export var type: CardType
@export var description: String

#not in uppercase to match signal from CardCombatManager
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

func _init(nName="", nCost="", nType=CardType.SPELL, nDescription=""):
	name = nName
	cost = nCost
	type = nType
	description = nDescription
