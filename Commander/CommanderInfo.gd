class_name CommanderInfo
extends Resource

signal cardPlayed

@export var health : HealthInfo
# will have a letter add for each elem of the Commander
@export var elemCommender : String
# DMG PART 
@export var multCoefDmg : int = 1
@export var addDmg : int = 0

# HAND PART
@export var limitSpellHand : int = 3
@export var limitPermanentHand : int = 3

# RESSOURCE PART
#it the max size of amoutElem string
@export var maxElem : int = 3
@export var amountElem : String
# each time this number get over 1, sub 1 and Cammander gain 1 of the last elem used
@export var currentRegenElem : float
# amount add to currentRegen per second
@export var regenElem : float = 0
@export var counter : Array[CounterInfo.idCounter]
