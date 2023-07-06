extends MenuDropdownButton


var level_up_button: Button
var level_to_max_button: Button


func setup() -> void:
	add_to_menu("Reset level & XP", reset_level_and_xp)
	
	level_up_button = add_to_menu("Level up", level_up)
	_update_level_up_button_text()
	
	var max_level: int = GlobalAccount.get_max_level()
	level_to_max_button = add_to_menu("Level to max (" + str(max_level) + ")", level_up_to_max)
	GlobalAccount.reached_max_level.connect(_on_reached_max_level)
	GlobalAccount.levelled_up.connect(_on_levelled_up)
	GlobalSignals.save_loaded.connect(_on_save_loaded)


func reset_level_and_xp() -> void:
	GlobalAccount.unlocked_items.clear()
	GlobalAccount.unlocked_items.append_array(GlobalAccount.starting_items)
	GlobalAccount.level = 1
	GlobalAccount.xp = 0
	_update_level_up_button_text()
	level_up_button.show()
	level_to_max_button.show()


func level_up() -> void:
	var xp_left: int = GlobalAccount.get_xp_to_next_level()
	if xp_left == -1:  # No next level
		return
	
	GlobalAccount.gain_xp(xp_left)


func level_up_to_max() -> void:
	var levels_left = GlobalAccount.get_max_level() - GlobalAccount.level
	if levels_left <= 0:
		return
	
	for i in levels_left:
		level_up()


func _on_reached_max_level(_max_level: int) -> void:
	if level_up_button:
		level_up_button.hide()
	if level_to_max_button:
		level_to_max_button.hide()


func _on_levelled_up(_level: int) -> void:
	_update_level_up_button_text()


func _update_level_up_button_text() -> void:
	if level_up_button:
		level_up_button.text = "Level up (" + str(GlobalAccount.level + 1) + ")"


func _on_save_loaded() -> void:
	_update_level_up_button_text()
	if GlobalAccount.is_max_level():
		_on_reached_max_level(-1)
