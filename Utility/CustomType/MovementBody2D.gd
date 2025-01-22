class_name MovementBody2D
extends CharacterBody2D

@export var speedMax : float : set = setSpeedMax, get = getSpeedMax
@export var acceleration : float :
	get:
		return acceleration
	set(nAcceleration):
		acceleration = nAcceleration
		 
@export var inertia : float : set = setInertia, get = getInertia

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
		energy = energy.lerp((dir * speedMax), acceleration * delta * (1 - inertia))
	else:
		energy = dir * speedMax * delta

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

func setSpeedMax(nSpeed: float) -> MovementBody2D:
	speedMax = nSpeed
	return self
	
func getSpeedMax() -> float:
	return speedMax

func addSpeed(nSpeed: float) -> MovementBody2D:
	speedMax += nSpeed
	if speedMax < 0:
		speedMax = 0
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
