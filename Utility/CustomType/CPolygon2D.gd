# It is custome class build for automatic build collission block base on a Polygon2D
class_name CPolygon2D
extends Polygon2D

func setBodyFromPolygon(poly: PackedVector2Array = []) -> void:
	var body = StaticBody2D.new()
	var collision_shape = CollisionPolygon2D.new()
	if poly.size() != 0:
		collision_shape.polygon = poly
	else:
		collision_shape.polygon = polygon
	body.add_child(collision_shape)
	add_child(body)
