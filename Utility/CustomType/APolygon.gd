# Custom class to build a Area2d from a Polygon2D and attach it a signal's function
class_name APolygon2D
extends Polygon2D

@onready var hitbox : Area2D

func setAreaFromPolygon(poly: PackedVector2Array = []) -> void:
	var area = Area2D.new()
	var collision_shape = CollisionPolygon2D.new()
	if poly.size() != 0:
		collision_shape.polygon = poly
	else:
		collision_shape.polygon = polygon
	area.add_child(collision_shape)
	add_child(area)
	hitbox = area
