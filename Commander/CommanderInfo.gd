class_name CommanderInfo
extends Resource

const Counter = preload("res://Cards/Counters/Counter.gd") 

# CARD PART
## the next card which is drawn is the lastId
@export var limitHand : int = 6
@export var counter : Array[Counter.idCounter]

@export var currentEnergy : float = 2
@export var energyRegen : float = 1 ## Per second
