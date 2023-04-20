class_name LogicTreeEntityArrayVariable
extends Node

@export var default_value: LogicTreeEntityArrayVariable

var value: Array[Occupant] = []


func _ready() -> void:
	reset_to_default()


func reset_to_default() -> void:
	value = []
	
	if default_value != null:
		value.append_array(default_value.value)
