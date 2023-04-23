@icon("res://Assets/art/logic-tree/effects/debug.png")
class_name LT_PrintToOutput
extends LogicTreeEffect


@export var text: String = ""
@export var bool_var: LT_BoolVariable
@export var int_var: LT_IntVariable
@export var float_var: LT_FloatVariable
@export var tile_var: LT_TileArrayVariable
@export var entity_var: LT_EntityArrayVariable
@export var item_var: LT_ItemArrayVariable


func perform_behavior() -> void:
	print("Logic tree debug output: ", text)
	if bool_var:
		print("[" + bool_var.name + "]: ", str(bool_var.value))
	if int_var:
		print("[" + int_var.name + "]: ", str(int_var.value))
	if float_var:
		print("[" + float_var.name + "]: ", str(float_var.value))
	if tile_var:
		print("[" + tile_var.name + "][Size=" + str(tile_var.value.size()) + "]: "
			+ str(tile_var.value))
	if entity_var:
		print("[" + entity_var.name + "][Size=" + str(entity_var.value.size()) + "]: "
			+ str(entity_var.value))
	if item_var:
		print("[" + item_var.name + "][Size=" + str(item_var.value.size()) + "]: "
			+ str(item_var.value))

