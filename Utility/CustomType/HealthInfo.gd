extends Resource

signal healthChanged(nHealth : int)
signal healthDropZero(infoHp : Resource)

@export var visibleHpBar : bool
@export var health : int : set = setHealth, get = getHealth
@export var maxHealth : int : set = setMaxHealth, get = getMaxHealth

var _health : int = 0
var _maxHealth : int = 0

func heal(nHeal: int) -> void:
	health += nHeal

func takeDamage(damage: int) -> void:
	health = _health - damage
		
# not emitting healthChanged
func setHealth(nHealth: int) -> void:
	_health = clampi(nHealth, 0, maxHealth)
	if health == 0:
		healthDropZero.emit(self)
	else:
		healthChanged.emit(_health)
	
func getHealth() -> int:
	return _health

func setMaxHealth(nMaxHealth: int) -> void:
	var diffHealth : int = nMaxHealth - _maxHealth
	_maxHealth = nMaxHealth
	health = _health + diffHealth
	
func getMaxHealth() -> int:
	return _maxHealth
