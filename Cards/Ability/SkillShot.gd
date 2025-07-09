extends CardAbility

signal SkillShot()
#signal HitSkillShot(target: Hitbox2D)

func resolve() -> void:
	var bullet := BacicProjectile.new()
	add_child(bullet)
	pass

func init() -> void:
	
	pass
