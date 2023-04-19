extends LogicTree


enum Comparison {
	HigherThan,
	AtLeast,
	EqualTo,
	NoMoreThan,
	LessThan
}

enum Check {
	All,
	Any
}

@export var item_array: LogicTreeItemArrayVariable
@export var comparison: Comparison = Comparison.HigherThan
@export_range(1, 10, 1, "or_greater") var tier: int
@export var check: Check = Check.All


func _ready() -> void:
	assert(item_array != null, "Item array variable not set")


func evaluate_condition() -> bool:
	for item in item_array.value:
		var does_pass_condition: bool = _item_passes_condition(item)
		if check == Check.All and does_pass_condition == false:
			return false
		if check == Check.Any and does_pass_condition:
			return true
	
	if check == Check.All:
		return true
	elif check == Check.Any:
		return false
	else:
		return false


func _item_passes_condition(item: Item) -> bool:
	match comparison:
		Comparison.AtLeast:
			return item.current_tier >= tier
		Comparison.HigherThan:
			return item.current_tier > tier
		Comparison.EqualTo:
			return item.current_tier == tier
		Comparison.LessThan:
			return item.current_tier < tier
		Comparison.NoMoreThan:
			return item.current_tier <= tier
	return false
