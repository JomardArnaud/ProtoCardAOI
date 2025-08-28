extends CardAbility

signal blank()

func resolve() -> void:
	blank.emit()
	pass
	
func init() -> void:
	pass
