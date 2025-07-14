extends CardAbility

signal SkillShot()
#signal HitSkillShot(target: Hitbox2D)

func resolve() -> void:
	var bullet := BacicProjectile.new()
	var cursor : Cursor = caster.get_node("Cursor")
	bullet.setDir(cursor.dir)
	bullet.position = cursor.global_position
	caster.add_child(bullet)

func init() -> void:
	
	pass
