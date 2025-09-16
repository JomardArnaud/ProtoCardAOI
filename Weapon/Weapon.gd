class_name Weapon
extends Node2D

signal reloading()
signal reloaded()
@export var info : WeaponInfo

##TODO pour que le HUD ne bouge pas en même temps que le joueur faut avoir top_level = true 

@onready var timerFireRate = %TimerFireRate
@onready var timerReload = %TimerRelooad

func _ready() -> void:
	timerFireRate.wait_time = info.fireRate
	timerReload.wait_time = info.speedReload
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action("Shoot") && timerFireRate.time_left == 0:
		shootBullet()
		
func shootBullet() -> void:
	#info.
	if info.leftInMagazine == 0:
		reloading.emit()
		await info.reload()
		reloaded.emit()
	pass
