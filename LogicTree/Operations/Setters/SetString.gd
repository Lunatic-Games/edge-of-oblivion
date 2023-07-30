@icon("res://Assets/art/logic-tree/operations/s.png")
class_name LT_SetString
extends LogicTreeSetterOperation


@export var string_variable: LT_StringVariable
@export var value: String = ""
@export var value_override: LT_StringVariable


func _ready() -> void:
	assert(string_variable != null, "String variable not set for '" + name + "'")


func perform_behavior() -> void:
	if value_override != null:
		value = value_override.value
	
	string_variable.value = value


func simulate_behavior() -> void:
	var current_val: String = string_variable.value
	perform_behavior()
	string_variable.last_simulated_value = string_variable.value
	string_variable.value = current_val
