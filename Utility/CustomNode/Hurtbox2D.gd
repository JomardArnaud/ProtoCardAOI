class_name Hurtbox2D
extends Area2D

signal takeHit(damage : float)

##TODO like health try to find a TakeHit function from parent and connect to hit 
func _ready() -> void:
	var parent = get_parent()
	if (parent.has_method("onTakeHit")):
		takeHit.connect(parent.onTakeHit.bind())
