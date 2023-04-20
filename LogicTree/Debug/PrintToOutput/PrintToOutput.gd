extends LogicTree


@export var text: String = ""
@export var bool_var: LogicTreeBoolVariable
@export var int_var: LogicTreeIntVariable
@export var float_var: LogicTreeFloatVariable
@export var tile_var: LogicTreeTileArrayVariable
@export var entity_var: LogicTreeEntityArrayVariable
@export var item_var: LogicTreeItemArrayVariable


func perform_behavior() -> void:
	print("Logic tree output: ", text)
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

