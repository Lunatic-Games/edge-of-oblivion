class_name Levelling
extends Node


signal levelled_up(new_level: int)

var entity: Entity = null
var data: LevellingData = null

var current_level: int = 1
var current_xp: int = 0


func _init(p_entity: Entity, p_data: LevellingData):
	entity = p_entity
	data = p_data


func gain_xp(amount: int):
	current_xp += amount
