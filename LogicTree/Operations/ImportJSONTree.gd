@icon("res://Assets/art/logic-tree/operations/random.png")
class_name LT_ImportJSONTree
extends LogicTreeOperation


@export_file var file_path
# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("hi")
	assert(file_path != null)
	assert(file_path != "")
	assert(FileAccess.file_exists(file_path))
	
	perform_behavior()

func perform_behavior():
	print_debug(FileAccess.open(file_path, FileAccess.READ).get_as_text())
