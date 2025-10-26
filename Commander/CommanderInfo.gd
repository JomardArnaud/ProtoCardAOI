extends Resource

const Counter = preload("res://Cards/Counters/Counter.gd") 

# CARD PART
## the next card which is drawn is the lastId
@export var limitHand : int = 6
@export var counter : Array[Counter.idCounter]

@export var currentEnergy : float = 2
@export var EnergyRegen : float = 0.125 ## 8 ticks per second
