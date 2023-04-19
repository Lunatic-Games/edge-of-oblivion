extends LogicTree


@export var bool_variable: LogicTreeBoolVariable


func _ready() -> void:
	assert(bool_variable != null, "Bool variable not set")


func perform_behavior() -> void:
	bool_variable.value = not bool_variable.value
