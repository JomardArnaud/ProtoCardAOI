class_name Weapon
extends Node2D

signal reloading()
signal reloaded()

const WeaponInfo = preload("res://Weapon/WeaponInfo.gd")

@onready var BacisProjectileScene = preload("res://Cards/Ability/SkillShot/BasicProjectile.tscn")

@export var info : WeaponInfo

@onready var timerFireRate = %TimerFireRate
@onready var timerReload = %TimerRelooad
@onready var holder : Commander
@onready var cursor = %Cursor

func _ready() -> void:
	if info != null:
		info.leftInMagazine = info.sizeMagazine
		timerFireRate.wait_time = info.fireRate
		timerReload.wait_time = info.speedReload
		if !timerReload.timeout.is_connected(reload):
			timerReload.timeout.connect(reload)

func setDirCursor(nDir: Vector2) -> void:
	cursor.setDir(nDir)

func tryShoot() -> bool:
	if (timerFireRate.time_left == 0 && info.leftInMagazine > 0):
		shootBullet()
		return true
	return false

func reload() -> void:
	info.leftInMagazine = info.sizeMagazine
	reloaded.emit()
		
func shootBullet() -> void:
	info.leftInMagazine -= 1
	if info.leftInMagazine == 0:
		reloading.emit()
		timerReload.start()
	var bullet := BacisProjectileScene.instantiate()
	bullet.dir = cursor.dir
	bullet.setSpeed(info.speedBullet)
	bullet.global_position = cursor.global_position
	holder.add_child(bullet)
	timerFireRate.start()
