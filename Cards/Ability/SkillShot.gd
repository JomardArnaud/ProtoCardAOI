extends CardAbilityNode

signal skillShot()

const PATH_PROJECTILE = "res://Cards/Ability/SkillShot/"

var defaultParam = {
	"speed": 2000,
	"damage" : 10,
	"radius" : 30,
	"projectileName": "BasicProjectile"
}

@onready var projectileNode : Node2D

func resolve() -> void:
	##TODO add a protection type by creating a projectile type
	var bullet = projectileNode.instantiate()
	var cursor : Cursor = caster.get_node("Cursor")
	bullet.dir = cursor.dir
	bullet.setSpeed(defaultParam.get("speed"))
	bullet.setDamage(defaultParam.get("damage"))
	bullet.setRadius(defaultParam.get("radius"))
	bullet.position = cursor.global_position
	caster.add_child(bullet)
	
func setupParam(nParam: Dictionary) -> void:
	defaultParam.merge(nParam, true)
	var pathProjectile = PATH_PROJECTILE + defaultParam.get("projectileName") + ".tscn"
	if ResourceLoader.exists(pathProjectile):
		var projectileScene = load(pathProjectile) as PackedScene
		projectileNode =  projectileScene.instantiate()
