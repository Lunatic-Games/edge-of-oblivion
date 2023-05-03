@icon("res://Assets/art/logic-tree/debug/debug.png")
class_name LT_TriggerAssert
extends LogicTreeDebug


@export_placeholder("Assert message") var message: String = ""


func perform_behavior() -> void:
	assert(false, message)

