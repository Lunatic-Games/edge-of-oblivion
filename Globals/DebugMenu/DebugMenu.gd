extends CanvasLayer

#const FADED_SCENE: PackedScene = preload("res://Data/Occupants/Enemies/Faded/Faded.tscn")
#const RANGER_SCENE: PackedScene = preload("res://Data/Occupants/Enemies/LostRanger/LostRanger.tscn")
#const PIKE_SCENE: PackedScene = preload("res://Data/Occupants/Enemies/ForswornPike/ForswornPike.tscn")
#const BOSS_SCENE: PackedScene = preload("res://Data/Occupants/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")
@onready var menus_container: BoxContainer = $Panel/MarginContainer/Menus


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


#func _process(_delta: float) -> void:	
#	if Input.is_action_just_pressed("debug_level_up"):
#		if GlobalGameState.player != null:
#			GlobalGameState.player.level_up()
#
#	if Input.is_action_just_pressed("debug_heal_player"):
#		if GlobalGameState.player != null:
#			GlobalGameState.player.heal(GlobalGameState.player.max_hp)
#
#	if Input.is_action_just_pressed("debug_damage_player"):
#		if GlobalGameState.player != null:
#			GlobalGameState.player.take_damage(int(float(GlobalGameState.player.max_hp) / 2.0))
#
#	if Input.is_action_just_pressed("debug_kill_all_enemies"):
#		# Iterate backwards since elements are deleted as they die
#		var enemies: Array[Enemy] = GlobalGameState.game.spawn_handler.spawned_enemies
#		for i in range(enemies.size() - 1, -1, -1):
#			enemies[i].take_damage(enemies[i].max_hp)
#
#	if Input.is_action_just_pressed("debug_restart_game"):
#		get_tree().reload_current_scene()
#
#	if Input.is_action_just_pressed("debug_spawn_faded"):
#		_spawn_enemy_scene(FADED_SCENE)
#
#	if Input.is_action_just_pressed("debug_spawn_ranger"):
#		_spawn_enemy_scene(RANGER_SCENE)
#
#	if Input.is_action_just_pressed("debug_spawn_pike"):
#		_spawn_enemy_scene(PIKE_SCENE)
#
#	if Input.is_action_just_pressed("debug_spawn_boss"):
#		_spawn_enemy_scene(BOSS_SCENE)
#
#
