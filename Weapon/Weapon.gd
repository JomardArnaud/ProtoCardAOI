class_name Weaponf
extends Node2D

signal reloading()
signal reloaded()

const WeaponInfo = preload("res://Weapon/WeaponInfo.gd")

@onready var BacisProjectileScene = preload("res://Cards/Ability/SkillShot/BasicProjectile.tscn")

@export var info : WeaponInfo
@export var holder : Commander

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
	var cursor : Cursor = holder.get_node("Cursor")
	bullet.dir = cursor.dir
	bullet.setSpeed(info.speedBullet)
	bullet.position = cursor.global_position
	holder.add_child(bullet)
	timerFireRate.start()
