@icon("res://Assets/art/logic-tree/conditionals/question-mark.png")
class_name LT_IfItemArrayContent
extends LogicTreeConditional


enum Comparison {
	EQUALS,
	IS_SUBSET_OF,
	IS_SUPERSET_OF
}

@export var input: LT_ItemArrayVariable
@export var comparison: Comparison
@export var compare_to: LT_ItemArrayVariable


func _ready() -> void:
	assert(input != null, "Input not set for '" + name + "'")
	assert(compare_to != null, "Compare-to not set for '" + name + "'")


func evaluate_condition() -> bool:
	match comparison:
		Comparison.EQUALS:
			return input.value == compare_to.value
		
		Comparison.IS_SUBSET_OF:
			for item in input.value:
				if compare_to.value.has(item) == false:
					return false
			return true
		
		Comparison.IS_SUPERSET_OF:
			for item in compare_to.value:
				if input.value.has(item) == false:
					return false
			return true
	
	return false
