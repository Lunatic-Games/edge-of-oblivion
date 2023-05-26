@icon("res://Assets/art/logic-tree/variables/v.png")
class_name LogicTreeVariable
extends LogicTree


func _ready() -> void:
	reset_to_default()


func perform_behavior():
	reset_to_default()


# To be overriden
func reset_to_default() -> void:
	pass
