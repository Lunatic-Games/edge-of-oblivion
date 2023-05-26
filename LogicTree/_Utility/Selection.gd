class_name LogicTreeSelection
extends Object


enum Operation {
	SET,
	ADD,
	SUBTRACT
}


static func perform_operation_on_tiles(lhs: Array[Tile], rhs: Array[Tile],
		operation: Operation, no_duplicates_in_result = true) -> Array[Tile]:
	
	var result: Array[Tile] = []
	
	if operation == Operation.SET:
		for tile in rhs:
			if no_duplicates_in_result == false or result.has(tile) == false:
				result.append(tile)
		
	if operation == Operation.ADD:
		for tile in lhs:
			if no_duplicates_in_result == false or result.has(tile) == false:
				result.append(tile)
		for tile in rhs:
			if no_duplicates_in_result == false or result.has(tile) == false:
				result.append(tile)

	if operation == Operation.SUBTRACT:
		for tile in lhs:
			if not tile in rhs and (no_duplicates_in_result == false or result.has(tile) == false):
				result.append(tile)
		
	return result
