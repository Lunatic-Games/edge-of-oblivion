extends MenuDropdownButton


var scenes: Dictionary = {
	"Game" : preload("res://Game/Game.tscn"),
	"Main menu" : preload("res://Menus/MainMenu/MainMenu.tscn"),
	"Precaching" : preload("res://Menus/Precaching/PrecachingScreen.tscn")
}


func setup() -> void:
	add_to_menu("Reload current", get_tree().reload_current_scene)
	add_spacer()
	
	for scene_name in scenes:
		add_to_menu(scene_name, get_tree().change_scene_to_packed.bind(scenes[scene_name]))
