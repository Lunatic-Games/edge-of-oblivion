class_name Player
extends "res://Data/Units/Unit.gd"

signal item_reached_max_tier

const LEVEL_UP_ANIMATION_TIME: float = 0.2

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

@onready var inventory: Inventory = $CanvasLayer/Inventory
@onready var player_camera: Camera2D = $PlayerCamera
@onready var experience_bar: ProgressBar = $CanvasLayer/ExperienceBar


func _physics_process(_delta: float) -> void:
	handle_movement()


func new_turn():
	moves_remaining = moves_per_turn


func handle_movement() -> void:
	if moves_remaining == 0 or lock_movement or hp <= 0:
		return
	
	if Input.is_action_just_pressed("up") and current_tile.top_tile:
		handle_move_or_wait(current_tile.top_tile)
	
	elif Input.is_action_just_pressed("down") and current_tile.bottom_tile:
		handle_move_or_wait(current_tile.bottom_tile)
	
	elif Input.is_action_just_pressed("left") and current_tile.left_tile:
		handle_move_or_wait(current_tile.left_tile)
	
	elif Input.is_action_just_pressed("right") and current_tile.right_tile:
		handle_move_or_wait(current_tile.right_tile)
	
	elif Input.is_action_just_pressed("wait"):
		handle_move_or_wait(current_tile)


func add_starting_items() -> void:
	var short_sword: ItemData = load("res://Data/Items/ShortSword/ShortSword.tres")
	inventory.gain_item(short_sword, false)


func handle_move_or_wait(tile: Tile):
	if tile != current_tile:
		move_to_tile(tile)
	
	moves_remaining -= 1
	assert(moves_remaining >= 0, "Negative moves remaining.")
	
	if moves_remaining == 0:
		GlobalSignals.player_finished_moving.emit(self)


func die() -> void:
	var camera_position_before: Vector2 = player_camera.global_position
	
	self.remove_child(player_camera)
	GameManager.board.add_child(player_camera)
	player_camera.set_owner(GameManager.board)
	
	player_camera.global_position = camera_position_before
	
	GlobalSignals.player_died.emit(self)
	super.die()


func gain_experience(experience: int) -> void:
	if current_level >= level_thresholds.size():
		return
	
	current_xp += experience
	
	if current_xp >= level_thresholds[current_level]:
		level_up()
	else:
		update_experience_bar()


func level_up() -> void:
	update_experience_bar()
	current_level += 1
	current_xp = 0
	GlobalSignals.player_levelled_up.emit(self)
	
	await get_tree().create_timer(LEVEL_UP_ANIMATION_TIME).timeout
	
	experience_bar.emit_particle()
	update_experience_bar()


func update_experience_bar() -> void:
	experience_bar.max_value = level_thresholds[current_level]
	
	var tween: Tween = create_tween()
	tween.tween_property(experience_bar, "value", current_xp, LEVEL_UP_ANIMATION_TIME)
