extends CardAbilityNode

signal blank()

func resolve() -> void:
	blank.emit()
	
func init() -> void:
	pass
