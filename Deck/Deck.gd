class_name Deck
extends MarginContainer

#tmp location

var ClassCardCollection = preload("res://Cards/CardCollection.gd")
var cardCollection : CardCollection

func _init() -> void:
	cardCollection = ClassCardCollection.new()

signal drawCard

var deck: Array[CardInfo]
