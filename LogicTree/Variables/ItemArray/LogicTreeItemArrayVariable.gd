class_name LogicTreeItemArrayVariable
extends Node

@export var default_value: LogicTreeItemArrayVariable

var value: Array[Item] = []


func _ready() -> void:
	reset_to_default()


func reset_to_default() -> void:
	value = []
	
	if default_value != null:
		value.append_array(default_value.value)
