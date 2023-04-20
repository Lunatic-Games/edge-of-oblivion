class_name LogicTreeFloatVariable
extends Node

@export var default_value: float = 0.0

var value: float = 0.0


func _ready() -> void:
	reset_to_default()


func reset_to_default() -> void:
	value = default_value
