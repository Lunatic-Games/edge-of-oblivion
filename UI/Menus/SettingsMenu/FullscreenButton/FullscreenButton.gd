extends "res://UI/Elements/MenuButton/MenuButton.gd"


const WINDOWED_TEXT: String = "Enable"
const FULLSCREEN_TEXT: String = "Disable"


func _ready() -> void:
	super._ready()
	update_text()


func _pressed() -> void:
	if _is_fullscreen():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	update_text()


func update_text():
	if _is_fullscreen():
		text = FULLSCREEN_TEXT
	else:
		text = WINDOWED_TEXT


func _is_fullscreen():
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
