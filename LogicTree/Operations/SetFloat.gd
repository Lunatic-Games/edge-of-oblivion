extends LogicTree


@export var float_variable: LT_FloatVariable
@export var value: float = 0.0


func _ready() -> void:
	assert(float_variable != null, "Float variable not set")


func perform_behavior() -> void:
	float_variable.value = value
