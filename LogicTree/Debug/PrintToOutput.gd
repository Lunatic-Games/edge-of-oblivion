@icon("res://Assets/art/logic-tree/debug/debug.png")
class_name LT_PrintToOutput
extends LogicTreeDebug


@export var text: String = ""
@export var bool_var: LT_BoolVariable
@export var int_var: LT_IntVariable
@export var float_var: LT_FloatVariable
@export var tile_array_var: LT_TileArrayVariable
@export var entity_array_var: LT_EntityArrayVariable
@export var item_array_var: LT_ItemArrayVariable


func perform_behavior() -> void:
	print("Logic tree debug output: ", text)
	if bool_var:
		print("[" + bool_var.name + "]: ", str(bool_var.value))
	if int_var:
		print("[" + int_var.name + "]: ", str(int_var.value))
	if float_var:
		print("[" + float_var.name + "]: ", str(float_var.value))
	if tile_array_var:
		print("[" + tile_array_var.name + "][Size=" + str(tile_array_var.value.size()) + "]: "
			+ str(tile_array_var.value))
	if entity_array_var:
		print("[" + entity_array_var.name + "][Size=" + str(entity_array_var.value.size()) + "]: "
			+ str(entity_array_var.value))
	if item_array_var:
		print("[" + item_array_var.name + "][Size=" + str(item_array_var.value.size()) + "]: "
			+ str(item_array_var.value))

