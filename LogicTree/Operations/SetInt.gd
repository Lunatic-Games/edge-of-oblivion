extends LogicTree


@export var int_variable: LT_IntVariable
@export var value: int = 0


func _ready() -> void:
	assert(int_variable != null, "Int variable not set")


func perform_behavior() -> void:
	int_variable.value = value
