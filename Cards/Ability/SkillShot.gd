extends CardAbility

signal SkillShot()
#signal HitSkillShot(target: Hitbox2D)

@onready var BacisProjectileScene = preload("res://Cards/Ability/SkillShot/BasicProjectile.tscn")

func resolve() -> void:
	var bullet := BacisProjectileScene.instantiate()
	var cursor : Cursor = caster.get_node("Cursor")
	bullet.dir = cursor.dir
	bullet.setSpeed(3000)
	bullet.position = cursor.global_position
	caster.add_child(bullet)
	pass

func init() -> void:
	
	pass
