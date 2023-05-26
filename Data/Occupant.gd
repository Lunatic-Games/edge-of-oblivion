class_name Occupant
extends Node2D

enum OccupantType {
	BLOCKING,
	COLLECTABLE,
	COMBATIVE
}

var occupant_type: OccupantType = OccupantType.BLOCKING
var current_tile: Tile = null

var pushable: bool = false
var damageable: bool = false


func collect() -> void:
	pass


func is_enemy() -> bool:
	return false
