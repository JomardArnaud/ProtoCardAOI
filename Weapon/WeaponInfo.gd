extends Resource

const WeaponEnum = preload("res://Weapon/WeaponEnum.gd")

@export_category("Stat weapon")
@export var fireRate : float = 0.2
@export var speedBullet : float = 3000
@export var sizeBullet : float = 30
@export var sizeMagazine : float = 8
@export var leftInMagazine : float = sizeMagazine
@export var speedReload : float = 0.1
@export var energyPerHit : float = 0.5
