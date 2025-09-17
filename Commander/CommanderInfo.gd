class_name CommanderInfo
extends Resource

@export var health : HealthInfo

# CARD PART
## the next card which is drawn is the lastId
var idDeckStartingCard : Array[int] = [0, 1, 0, 1, 0, 4]
@export var limitHand : int = 4


# RESSOURCE PART
@export var currentRegenElem : float
# amount add to currentRegen per second
@export var counter : Array[CounterInfo.idCounter]
