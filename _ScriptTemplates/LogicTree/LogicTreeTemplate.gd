extends LogicTree


func perform_behavior() -> void:
	# Can be overriden to define new behavior
	pass


func evaluate_condition() -> bool:
	# Can be overriden to make children evaluation to only occur in certain conditions
	return true
