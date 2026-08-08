class_name HealthInfo
extends Resource

signal infoChanged()
signal healthChanged(amountChanged : float)
signal healthDropZero()

@export var visibleHpBar : bool = true :
	set(nVisible):
		visibleHpBar = nVisible
		infoChanged.emit()
@export var maxHealth : float = 100 : set = setMaxHealth, get = getMaxHealth
@export var health : float = 0 : set = setHealth, get = getHealth

func heal(nHeal: float) -> void:
	setHealth(health + nHeal)

func takeDamage(damage: float) -> void:
	setHealth(health - damage)

func setHealth(nHealth: float) -> void:
	var bufferHealth = health
	health = clampf(nHealth, 0, maxHealth)
	if bufferHealth != health:
		infoChanged.emit()
		if health == 0:
			healthDropZero.emit()
		else:
			healthChanged.emit(health - bufferHealth)
	
func getHealth() -> float:
	return health

func setMaxHealth(nMaxHealth: float) -> void:
	var diffHealth : float = nMaxHealth - maxHealth
	maxHealth = nMaxHealth
	infoChanged.emit()
	
func getMaxHealth() -> float:
	return maxHealth
