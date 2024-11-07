class_name HealthInfo
extends Resource

#ignore
signal healthChanged
signal healthDropZero

@export var visibleHpBar : bool
@export var health : float
@export var maxHealth : float

func heal(nHeal: float) -> void:
	health = clampf(health + nHeal, health, maxHealth)
	emit_signal("healthChanged", health)

func takeDamage(damage: float) -> void:
	health = clampf(health - damage, 0, health)
	emit_signal("healthChanged", health)
	if health == 0:
		emit_signal("healthDropZero")

# not emitting healthChanged
func setHealth(nHealth: float) -> HealthInfo:
	health = clampf(nHealth, 0, maxHealth)
	if health == 0:
		emit_signal("healthDropZero")
	else:
		emit_signal("healthChanged", health)
	return self
	
func getHealth() -> float:
	return health

func setMaxHealth(nMaxHealth: float) -> HealthInfo:
	maxHealth = nMaxHealth
	return self
	
func getMaxHealth() -> float:
	return maxHealth
