class_name HealthInfo
extends Resource

signal healthChanged
signal healthDropZero

@export var visibleHpBar : bool
@export var health : float
@export var maxHealth : float

@export var minusFlatDirectDmg : float
@export var minusFlatIndirectDmg : float
#reduce dmg after minus flat dmg apply, by 1 - minusCoef * damageAfterMinusFlat if minus exceed [0,1] it will either heal or overcap dmg
@export var minusCoefDirectDmg : float
@export var minusCoefIndirectDmg : float


func heal(nHeal: float) -> void:
	health = clampf(health + nHeal, health, maxHealth)
	healthChanged.emit(health)

func takeDirectDamage(damage: float) -> void:
	health = clampf(health - ((damage - minusFlatDirectDmg) * (1 - minusCoefDirectDmg)), 0, health)
	healthChanged.emit(health)
	if health == 0:
		healthDropZero.emit()

func takeIndirectDamage(damage: float) -> void:
	health = clampf(health - ((damage - minusFlatIndirectDmg) * (1 - minusCoefIndirectDmg)), 0, health)
	healthChanged.emit(health)
	if health == 0:
		healthDropZero.emit()


# not emitting healthChanged
func setHealth(nHealth: float) -> HealthInfo:
	health = clampf(nHealth, 0, maxHealth)
	if health == 0:
		healthDropZero.emit()
	else:
		healthChanged.emit(health)
	return self
	
func getHealth() -> float:
	return health

func setMaxHealth(nMaxHealth: float) -> HealthInfo:
	var diffHealth : int = nMaxHealth - maxHealth
	maxHealth = nMaxHealth
	health += diffHealth
	return self
	
func getMaxHealth() -> float:
	return maxHealth
