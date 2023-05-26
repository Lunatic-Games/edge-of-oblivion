@icon("res://Assets/art/logic-tree/effects/color.png")
class_name LT_SetItemsColor
extends LogicTreeEffect


enum ItemColor {
	WHITE,
	RED,
	GREEN,
	BLUE,
	ORANGE,
	PURPLE
}

const COLOR_VALUES: Dictionary = {
	ItemColor.WHITE: Color.WHITE,
	ItemColor.RED: Color.RED,
	ItemColor.GREEN: Color.LIME_GREEN,
	ItemColor.BLUE: Color.LIGHT_SKY_BLUE,
	ItemColor.ORANGE: Color.LIGHT_SALMON
}

@export var items: LT_ItemArrayVariable
@export var color: ItemColor = ItemColor.WHITE


func _ready() -> void:
	assert(items != null, "Items not set for '" + name + "'")


func perform_behavior() -> void:
	for item in items.value:
		item.set_sprite_color(COLOR_VALUES[color])
