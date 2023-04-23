@icon("res://Assets/art/logic-tree/effects/debug.png")
class_name LT_TriggerAssert
extends LogicTreeEffect


@export_placeholder("Assert message") var message: String = ""


func perform_behavior() -> void:
	assert(false, message)

