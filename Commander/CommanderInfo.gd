class_name CommanderInfo
extends Resource

signal energyChanged

const Counter = preload("res://Cards/Counters/Counter.gd") 

# CARD PART
## the next card which is drawn is the lastId
@export var nbCardStartingHand : int = 6
@export var handSizeLimit : int = 6
@export var counter : Array[Counter.idCounter]

@export var currentEnergy : float = 2
@export var energyRegen : float = 0.5 ## Per second

func setEnergy(nEnergy: float) -> void:
	currentEnergy = nEnergy
	emit_signal("energyChanged")

func useEnergy(costEnergy: float) -> void:
	setEnergy(currentEnergy - costEnergy) 
