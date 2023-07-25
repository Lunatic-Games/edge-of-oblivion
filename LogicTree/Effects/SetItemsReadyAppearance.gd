@icon("res://Assets/art/logic-tree/effects/check-mark.png")
class_name LT_SetItemsReadyAppearance
extends LogicTreeEffect


@export var items: LT_ItemArrayVariable
@export var appear_ready: bool = true
@export var animate: bool = true


func _ready() -> void:
	assert(items != null, "Items not set for '" + name + "'")


func perform_behavior() -> void:
	for item in items.value:
		if appear_ready:
			item.appear_ready(animate)
		else:
			item.appear_unready(animate)
