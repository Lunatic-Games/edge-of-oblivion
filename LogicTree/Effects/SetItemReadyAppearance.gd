extends LogicTree


@export var item_array: LT_ItemArrayVariable
@export var appear_ready: bool = true


func _ready() -> void:
	assert(item_array != null, "Item array not set")


func perform_behavior() -> void:
	for item in item_array.value:
		if appear_ready:
			item.appear_ready()
		else:
			item.appear_unready()
