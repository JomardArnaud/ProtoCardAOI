extends Resource

const CardEnum = preload("res://Cards/CardEnum.gd")

@export var name: String
@export var cost: int
@export var type: CardEnum.CardType
@export var family: String
@export var tag : Dictionary
@export var abilities: Dictionary[int, CardAbility]
	
func _init(nName="", nCost : int = 1, nType = CardEnum.CardType.DASH, nAbilites={}):
	name = nName
	cost = nCost
	type = nType
	abilities = nAbilites
