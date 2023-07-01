extends "res://UI/Elements/MenuButton/MenuButton.gd"


const WINDOWED_TEXT: String = "Enable"
const FULLSCREEN_TEXT: String = "Disable"


func _ready() -> void:
	super._ready()
	_update_text()
	get_viewport().size_changed.connect(_on_viewport_size_changed)


func _pressed() -> void:
	if _is_fullscreen():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_update_text()


func _update_text():
	if _is_fullscreen():
		text = FULLSCREEN_TEXT
	else:
		text = WINDOWED_TEXT


func _is_fullscreen():
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN


# Viewport size changes on fullscreen changing
# Catches any case where the window mode changes without using the button (e.g. debug overlay)
func _on_viewport_size_changed():
	_update_text()
