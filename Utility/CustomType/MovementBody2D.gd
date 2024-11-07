class_name MovementBody2D
extends CharacterBody2D

@export var inertia : float : set = setInertia, get = getInertia
@export var speed : float : set = setSpeed, get = getSpeed # distance per second

@onready var dir : Vector2 : set = setDir, get = getDir 
@onready var energy : Vector2 : set = setEnergy, get = getEnergy
@onready var dirLock := false

func resetEnergy() -> void:
	energy = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	updateDir()
	updateEnergy(delta)
	set_velocity(energy)
	move_and_slide()

func updateDir() -> void:
	pass

func updateEnergy(delta: float):
	if !dirLock :
		energy = dir * speed * delta * 100 + energy * inertia
	else :
		energy = dir * speed * delta

func lockDir(nLock: bool) -> MovementBody2D:
	dirLock = nLock
	return self	

### all getter | setter ###
func setInertia(nInertia: float) -> MovementBody2D:
	inertia = clampf(nInertia, 0, 1)
	return self

func getInertia() -> float:
	return inertia
	
func addInertia(aInertia: float) -> MovementBody2D:
	inertia = clampf(inertia + aInertia, 0, 1)
	return self

func setSpeed(nSpeed: float) -> MovementBody2D:
	speed = nSpeed
	return self
	
func getSpeed() -> float:
	return speed

func addSpeed(aSpeed: float) -> MovementBody2D:
	speed += aSpeed
	if speed < 0:
		speed = 0
	return self

func setDir(nDir: Vector2) -> MovementBody2D:
	if !dirLock:
		dir = nDir
	return self
	
func getDir() -> Vector2:
	return dir

func setEnergy(nEnergy: Vector2) -> MovementBody2D:
	energy = nEnergy
	return self
	
func getEnergy() -> Vector2:
	return energy
