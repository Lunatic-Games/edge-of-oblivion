class_name LogicTreeTileArrayVariable
extends Node

@export var default_value: LogicTreeTileArrayVariable

var value: Array[Tile] = []


func _ready() -> void:
	reset_to_default()


func reset_to_default() -> void:
	value = []
	
	if default_value != null:
		value.append_array(default_value.value)
