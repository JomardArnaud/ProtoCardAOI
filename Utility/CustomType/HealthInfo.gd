class_name HealthInfo
extends Resource

signal healthChanged
signal healthDropZero

@export var visibleHpBar : bool
@export var health : float
@export var maxHealth : float

func heal(nHeal: float) -> void:
	health = clampf(health + nHeal, health, maxHealth)
	healthChanged.emit(health)

func takeDamage(damage: float) -> void:
	health = clampf(health - damage, 0, health)
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
