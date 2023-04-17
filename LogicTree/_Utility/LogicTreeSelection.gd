class_name LogicTreeSelection
extends Object


enum Operation {
	SET,
	ADD,
	INTERSECTION,
	SUBTRACT
}


static func perform_operation_on_tiles(lhs: Array[Tile], rhs: Array[Tile],
		operation: Operation) -> Array[Tile]:
	
	var result: Array[Tile] = []
	
	if operation == Operation.SET:
		return rhs
		
	if operation == Operation.ADD:
		for node in lhs:
			result.append(node)
		for node in rhs:
			result.append(node)
	
	if operation == Operation.INTERSECTION:
		for node in rhs:
			if node in lhs:
				result.append(node)

	if operation == Operation.SUBTRACT:
		for node in lhs:
			if not node in rhs:
				result.append(node)
		
	return result
