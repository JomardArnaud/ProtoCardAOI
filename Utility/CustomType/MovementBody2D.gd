class_name MovementBody2D
extends CharacterBody2D

## ratio stand 1point in speed X5 accel X6
@export var speed : float = 1000 : set = setSpeed, get = getSpeed
@export var acceleration : float = 5000 : set = setAcceleration, get = getAcceleration
@export var deceleration : float = 6000
@export var uTurnAccel : float = 4
@export var steeringAccel : float = 3
@export_range(0, 1) var inertia : float = 0.1 : set = setInertia, get = getInertia

@onready var dir : Vector2 : set = setDir, get = getDir 
@onready var energy : Vector2 : set = setEnergy, get = getEnergy
@onready var dirLock := false

func resetEnergy(gradiant : Vector2 = Vector2.ZERO) -> void:
	setEnergy(energy * gradiant)

func _physics_process(delta: float) -> void:
	updateDir()
	updateEnergy(delta)
	set_velocity(energy)
	move_and_slide()

func updateDir() -> void:
	pass

func updateEnergy(delta: float):
	if dir == Vector2.ZERO:
		setEnergy(energy.move_toward(Vector2.ZERO, deceleration * (1 - inertia) * delta))
	else:
		var turningAngle : float = energy.normalized().dot(dir)
		var tmpAccel : float = acceleration
		if turningAngle < 0 :
			tmpAccel *= uTurnAccel
		elif turningAngle < 0.85 :
			tmpAccel *= steeringAccel
		var finaLAccel = tmpAccel * (1 - inertia)
		setEnergy(energy.move_toward(dir * speed, finaLAccel * delta))

func lockDir(nLock: bool) -> MovementBody2D:
	dirLock = nLock
	return self	

### all getter | setter ###
func setAcceleration(nAcceleration: float) -> MovementBody2D:
	acceleration = nAcceleration
	return self

func getAcceleration() -> float:
	return acceleration
	
func addAcceleration(aAcceleration: float) -> MovementBody2D:
	setAcceleration(acceleration + aAcceleration)
	return self

func setInertia(nInertia: float) -> MovementBody2D:
	inertia = clampf(nInertia, 0, 1)
	return self

func getInertia() -> float:
	return inertia
	
func addInertia(aInertia: float) -> MovementBody2D:
	setInertia(clampf(inertia + aInertia, 0, 1))
	return self

func setSpeed(nSpeed: float) -> MovementBody2D:
	speed = nSpeed
	if speed < 0:
		speed = 0
	return self
	
func getSpeed() -> float:
	return speed

func addSpeed(nSpeed: float) -> MovementBody2D:
	setSpeed(speed + nSpeed)
	return self

func setDir(nDir: Vector2) -> MovementBody2D:
	if !dirLock:
		dir = nDir.normalized()
	return self
	
func getDir() -> Vector2:
	return dir

func setEnergy(nEnergy: Vector2) -> MovementBody2D:
	energy = nEnergy
	return self
	
func getEnergy() -> Vector2:
	return energy
