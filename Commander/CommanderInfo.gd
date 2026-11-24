class_name CommanderInfo
extends Resource

signal energyChanged
signal maxEnergyChanged

const Counter = preload("res://Cards/Counters/Counter.gd") 

# CARD PART
## the next card which is drawn is the lastId
@export var nbCardStartingHand : int = 6
@export var handSizeLimit : int = 6
@export var counter : Array[Counter.idCounter]

@export var maxEnergy : float = 3
@export var currentEnergy : float = 2
@export var energyRegen : float = 0.2 ## Per second

func setEnergy(nEnergy: float) -> void:
	var clamped := clampf(nEnergy, 0.0, maxEnergy)
	if clamped != currentEnergy:
		currentEnergy = clamped
		energyChanged.emit()

func useEnergy(costEnergy: float) -> void:
	setEnergy(currentEnergy - costEnergy)
	
func setMaxEnergy(nMaxEnergy: float) -> void:
	maxEnergy = nMaxEnergy
	maxEnergyChanged.emit()
