class_name MenuDropdownButton
extends Button


const MENU_BUTTON_SCENE: PackedScene = preload("res://Globals/DebugMenu/MenuButton/DebugMenuButton.tscn")

@onready var menu: BoxContainer = $Menu


# Put menu population into this function so it will only be called if the debug menu is enabled
func setup() -> void:
	pass


func add_to_menu(button_text: String, function: Callable) -> Button:
	var new_button: Button = MENU_BUTTON_SCENE.instantiate()
	new_button.text = button_text
	new_button.pressed.connect(function)
	menu.add_child(new_button)
	return new_button


func _on_toggled(is_button_pressed: bool) -> void:
	menu.visible = is_button_pressed
