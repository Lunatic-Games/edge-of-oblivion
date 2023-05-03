@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfEntityArrayContent
extends LogicTreeConditional


enum Comparison {
	EQUALS,
	IS_SUBSET_OF,
	IS_SUPERSET_OF
}

@export var input: LT_EntityArrayVariable
@export var comparison: Comparison
@export var compare_to: LT_EntityArrayVariable


func _ready() -> void:
	assert(input != null, "Input not set for '" + name + "'")
	assert(compare_to != null, "Compare-to not set for '" + name + "'")


func evaluate_condition() -> bool:
	match comparison:
		Comparison.EQUALS:
			return input.value == compare_to.value
		
		Comparison.IS_SUBSET_OF:
			for entity in input.value:
				if compare_to.value.has(entity) == false:
					return false
			return true
		
		Comparison.IS_SUPERSET_OF:
			for entity in compare_to.value:
				if input.value.has(entity) == false:
					return false
			return true
	
	return false
