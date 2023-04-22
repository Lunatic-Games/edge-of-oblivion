extends LogicTree


@export var bool_variable: LT_BoolVariable


func _ready() -> void:
	assert(bool_variable != null, "Bool variable not set")


func perform_behavior() -> void:
	bool_variable.value = not bool_variable.value
