class_name LogicTreeBoolVariable
extends Node

@export var default_value: bool = false

var value: bool = false


func _ready() -> void:
	reset_to_default()


func reset_to_default() -> void:
	value = default_value
