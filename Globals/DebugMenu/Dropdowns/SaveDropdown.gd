extends MenuDropdownButton


func setup() -> void:
	add_to_menu("Save progress", save_progress)
	add_to_menu("Load progress", load_progress)


func save_progress() -> void:
	Saving.save_to_file()


func load_progress() -> void:
	Saving.load_from_file()
