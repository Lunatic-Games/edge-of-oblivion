extends Node2D

enum occupantTypes {
	blocking,
	collectable,
	combative
}
var occupantType = occupantTypes.blocking

func collect():
	pass

func isEnemy():
	return false
