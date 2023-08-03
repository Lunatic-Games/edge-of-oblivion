class_name Levelling
extends Node


var entity: Entity = null
var data: LevellingData = null

var current_level: int = 1
var current_xp: int = 0


func _init(p_entity: Entity, p_data: LevellingData):
	entity = p_entity
	data = p_data
