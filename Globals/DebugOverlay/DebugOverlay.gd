extends CanvasLayer


@onready var menus_container: BoxContainer = $Panel/MarginContainer/Menus
@onready var select_tiles_menu: DebugSelectTilesMenu = $SelectTilesMenu


func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()
		return
	
	hide()
	
	for menu_button in menus_container.get_children():
		menu_button.setup()
		menu_button.pressed.connect(_on_menu_button_pressed.bind(menu_button))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_menu"):
		if visible:
			hide()
		else:
			show()


func _on_menu_button_pressed(pressed_button: Button) -> void:
	for menu_button in menus_container.get_children():
		if menu_button != pressed_button:
			menu_button.button_pressed = false
