class_name Occupant
extends Node2D

enum occupantTypes {
	blocking,
	collectable,
	combative
}
var occupantType = occupantTypes.blocking

var pushable: bool = false
var damageable: bool = false

func collect():
	pass

func isEnemy():
	return false
