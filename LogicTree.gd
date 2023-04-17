extends LogicTree



func perform_behavior(_context: LogicTreeContext) -> void:
	# Can be overriden to define new behavior
	pass



func evaluate_condition(_context: LogicTreeContext) -> bool:
	# Can be overriden to make children evaluation to only occur in certain conditions
	return true



func mutate_context(context: LogicTreeContext) -> LogicTreeContext:
	# Can be overriden to mutate the context to be used for children trees
	# Make sure any by-reference members are detangled if making a new context
	return context

