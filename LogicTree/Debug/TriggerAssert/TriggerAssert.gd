extends LogicTree


@export_placeholder("ASSERT MESSAGE") var message: String = ""


func perform_behavior() -> void:
	assert(false, message)

