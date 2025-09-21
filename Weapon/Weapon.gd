class_name Weapon
extends Node2D

signal reloading()
signal reloaded()

@onready var BacisProjectileScene = preload("res://Cards/Ability/SkillShot/BasicProjectile.tscn")

@export var info : WeaponInfo

##TODO pour que le HUD ne bouge pas en même temps que le joueur faut avoir top_level = true 

@onready var timerFireRate = %TimerFireRate
@onready var timerReload = %TimerRelooad

func _ready() -> void:
	timerFireRate.wait_time = info.fireRate
	timerReload.wait_time = info.speedReload
	timerReload.timeout.connect(reload)
	
func _process(delta: float) -> void:
	if InputManager.get_instance().isShooting() && timerFireRate.time_left == 0 && info.leftInMagazine > 0:
		shootBullet()
		
func reload() -> void:
	info.leftInMagazine = info.sizeMagazine
	reloaded.emit()
		
func shootBullet() -> void:
	info.leftInMagazine -= 1
	if info.leftInMagazine == 0:
		reloading.emit()
		timerReload.start()
	var bullet := BacisProjectileScene.instantiate()
	## TODO just to test need to rework on commander node to add cursor and set PlayerNode to type Commander and node Commander inherit of MovementBody2D  
	var tmpPlayer = get_tree().get_nodes_in_group("Players")[0]
	var cursor : Cursor = tmpPlayer.get_node("Cursor")
	bullet.dir = cursor.dir
	bullet.setSpeed(info.speedBullet)
	bullet.position = cursor.global_position
	tmpPlayer.add_child(bullet)
	timerFireRate.start()
