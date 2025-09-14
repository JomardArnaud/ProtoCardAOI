class_name WeaponInfo
extends Resource

const WeaponEnum = preload("res://Weapon/WeaponEnum.gd")

signal reload()

@export_category("Stat weapong")
@export var fireRate : float
@export var speedBullet : float
@export var sizeMagazine : float
