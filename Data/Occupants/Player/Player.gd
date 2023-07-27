class_name Player
extends Unit


const EXPERIENCE_BAR_UPDATE_ANIMATION_TIME: float = 0.2
const DEFAULT_SCALE: Vector2 = Vector2(0.125, 0.125)
const SQUISHED_SCALE: Vector2 = Vector2(0.1, 0.1)

var moves_per_turn: int = 1
var moves_remaining: int = moves_per_turn
var current_xp: int = 0
var current_level: int = 1
var level_thresholds = {
	1: 1,
	2: 3,
	3: 3,
	4: 4,
	5: 5,
	6: 5,
	7: 5,
	8: 5,
	9: 5,
	10: 5
}
var starting_items: Array[Resource] = [
	load("res://Data/Items/ShortSword/ShortSword.tres")
]
var stretch_tween: Tween = null

@onready var inventory: Inventory = $CanvasLayer/Inventory
@onready var experience_bar: ProgressBar = $CanvasLayer/ExperienceBar


func _ready() -> void:
	update_experience_bar()
	GlobalSignals.player_spawned.emit(self)


func _physics_process(_delta: float) -> void:
	handle_movement()


func reset_moves_remaining():
	moves_remaining = moves_per_turn
	var modulate_tween: Tween = create_tween().set_parallel()
	modulate_tween.tween_property($Sprite2D.material, "shader_parameter/modulate:a", 1.0, 0.2)


func handle_movement() -> void:
	if hp <= 0 or GlobalGameState.game_ended or GlobalGameState.in_upgrade_menu:
		return
	
	if moves_remaining == 0 or lock_movement:
		return
	
	if Input.is_action_pressed("up") and current_tile.top_tile:
		handle_move_or_wait(current_tile.top_tile)
	
	elif Input.is_action_pressed("down") and current_tile.bottom_tile:
		handle_move_or_wait(current_tile.bottom_tile)
	
	elif Input.is_action_pressed("left") and current_tile.left_tile:
		handle_move_or_wait(current_tile.left_tile)
	
	elif Input.is_action_pressed("right") and current_tile.right_tile:
		handle_move_or_wait(current_tile.right_tile)
	
	elif Input.is_action_pressed("wait"):
		handle_move_or_wait(current_tile)


func add_starting_items() -> void:
	for item_data in starting_items:
		inventory.gain_item(item_data, false)


func handle_move_or_wait(tile: Tile):
	if tile != current_tile:
		move_to_tile(tile)
	
	moves_remaining -= 1
	assert(moves_remaining >= 0, "Negative moves remaining.")
	
	if moves_remaining == 0:
		var modulate_tween: Tween = create_tween().set_parallel()
		modulate_tween.tween_property($Sprite2D.material, "shader_parameter/modulate:a", 0.3, 0.2)
		GlobalSignals.player_finished_moving.emit(self)
	
	stretch_tween = create_tween()
	stretch_tween.tween_property($Sprite2D, "scale", SQUISHED_SCALE, 0.25)
	await stretch_tween.finished
	stretch_tween = create_tween()
	stretch_tween.tween_property($Sprite2D, "scale", DEFAULT_SCALE, 0.25)


func die() -> void:
	GlobalSignals.player_died.emit(self)
	super.die()


func heal(heal_amount: int) -> int:
	var amount_healed: int = super.heal(heal_amount)
	GlobalSignals.player_healed.emit(self, amount_healed)
	return amount_healed


func gain_experience(experience: int) -> void:
	if current_level >= level_thresholds.size():
		return
	
	current_xp += experience
	
	if current_xp >= level_thresholds[current_level]:
		level_up()
	else:
		update_experience_bar()


func level_up() -> void:
	current_level += 1
	current_xp = 0
	GlobalSignals.player_levelled_up.emit(self)
	
	var tween: Tween = create_tween()
	tween.tween_property(experience_bar, "value", experience_bar.max_value,
		EXPERIENCE_BAR_UPDATE_ANIMATION_TIME)
	await tween.finished
	
	experience_bar.emit_particle()
	update_experience_bar()


func update_experience_bar() -> void:
	var max_level = level_thresholds.keys().max()
	if current_level > max_level:
		experience_bar.max_value = level_thresholds[max_level]
	else:
		experience_bar.max_value = level_thresholds[current_level]
	
	if current_xp > experience_bar.value:
		var tween: Tween = create_tween()
		tween.tween_property(experience_bar, "value", current_xp,
			EXPERIENCE_BAR_UPDATE_ANIMATION_TIME)
	else:
		experience_bar.value = current_xp


func set_strech_animation_paused(should_pause: bool):
	if is_instance_valid(stretch_tween):
		if should_pause:
			stretch_tween.pause()
		else:
			stretch_tween.play()
		
