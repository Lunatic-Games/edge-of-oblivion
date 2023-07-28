class_name DebugSelectTilesMenu
extends ColorRect


var max_number_selections: int = -1
var n_selections = 0
var on_select: Callable

@onready var select_info_label: Label = $VBoxContainer/SelectInfo


func _input(event: InputEvent) -> void:
	if visible == false:
		return
	
	if event.is_action_pressed("debug_menu_end_selection"):
		hide()
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		attempt_select()


func attempt_select() -> void:
	if GlobalGameState.game == null:
		return
	
	# Use game because of debug menu being on a different canvas layer
	var pos: Vector2 = GlobalGameState.game.get_global_mouse_position()
	var tile: Tile = GlobalGameState.board.get_tile_at_position(pos)
	if tile != null:
		on_select.call(tile)
	n_selections += 1
	if max_number_selections > -1 and n_selections >= max_number_selections:
		hide()


# Pass a callable that takes a tile as its sole argument
func begin_selection(on_select_function: Callable, info_text: String = "Select Tiles",
		max_n_selections: int = -1) -> void:
	select_info_label.text = info_text
	on_select = on_select_function
	n_selections = 0
	max_number_selections = max_n_selections
	show()
