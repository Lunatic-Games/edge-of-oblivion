class_name Occupant
extends Node2D

enum OccupantTypes {
	BLOCKING,
	COLLECTABLE,
	COMBATIVE
}

var occupantType = OccupantTypes.BLOCKING

var pushable: bool = false
var damageable: bool = false


func collect():
	pass


func is_enemy():
	return false
