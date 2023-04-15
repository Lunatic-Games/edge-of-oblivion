extends LogicTree


enum Operation {
	SET,
	ADD,
	INTERSECTION,
	SUBTRACT
}

@export_flags("Up", "Right", "Down", "Left") var directions: int
@export var operation: Operation


func evaluate(targets: Array[Node]) -> bool:
	
	return true
