@icon("res://Assets/art/logic-tree/operations/n.png")
class_name LT_SetString
extends LogicTreeOperation


@export var string_variable: LT_StringVariable
@export var value: String = ""


func _ready() -> void:
	assert(string_variable != null, "String variable not set for '" + name + "'")


func perform_behavior() -> void:
	string_variable.value = value
