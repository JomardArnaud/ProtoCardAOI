class_name HealthInfo
extends Resource

signal infoChanged()
signal healthChanged(amountChanged : int)
signal healthDropZero()

@export var visibleHpBar : bool = true :
	set(nVisible):
		visibleHpBar = nVisible
		infoChanged.emit()
@export var maxHealth : int = 100 : set = setMaxHealth, get = getMaxHealth
@export var health : int = 0 : set = setHealth, get = getHealth

func heal(nHeal: int) -> void:
	health += nHeal

func takeDamage(damage: int) -> void:
	health = health - damage
		
# not emitting healthChanged
func setHealth(nHealth: int) -> void:
	var bufferHealth = health
	health = clampi(nHealth, 0, maxHealth)
	if bufferHealth != health:
		infoChanged.emit()
		if health == 0:
			healthDropZero.emit()
		else:
			healthChanged.emit(health - bufferHealth)
	
func getHealth() -> int:
	return health

func setMaxHealth(nMaxHealth: int) -> void:
	var diffHealth : int = nMaxHealth - maxHealth
	maxHealth = nMaxHealth
	#health = health + diffHealth
	infoChanged.emit()
	
func getMaxHealth() -> int:
	return maxHealth
