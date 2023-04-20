class_name LogicTreeIntVariable
extends Node

@export var default_value: int = 0

var value: int = 0


func _ready() -> void:
	reset_to_default()


func reset_to_default() -> void:
	value = default_value
