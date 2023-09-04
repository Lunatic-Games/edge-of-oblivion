class_name InputController
extends RefCounted


const DEFAULT_SCALE: Vector2 = Vector2(1, 1)
const SQUISHED_SCALE: Vector2 = Vector2(0.7, 0.7)
const UNREADY_FADE_OUT_TIME_SECONDS: float = 0.2
const UNREADY_ALPHA: float = 0.3
const READY_FADE_IN_TIME_SECONDS: float = 0.2
const EXTRA_FADE_DURATION_SECONDS: float = 0.1  # Can make it feel like you can move earlier

var entity: Entity = null
var data: InputControllerData = null

var is_movement_locked: bool = false
var moves_remaining: int = 0


func _init(p_entity: Entity, p_data: InputControllerData):
	entity = p_entity
	data = p_data
	moves_remaining = data.moves_per_turn


func check_for_input(time_for_turn_seconds: float):
	if !entity.health.is_alive() or moves_remaining == 0 or is_movement_locked:
		return
	
	var current_tile: Tile = entity.occupancy.primary_tile
	if Input.is_action_pressed("up"):
		handle_move_or_wait(current_tile.top_tile, time_for_turn_seconds)
	
	elif Input.is_action_pressed("down"):
		handle_move_or_wait(current_tile.bottom_tile, time_for_turn_seconds)
	
	elif Input.is_action_pressed("left"):
		handle_move_or_wait(current_tile.left_tile, time_for_turn_seconds)
	
	elif Input.is_action_pressed("right"):
		handle_move_or_wait(current_tile.right_tile, time_for_turn_seconds)
	
	elif Input.is_action_pressed("wait"):
		handle_move_or_wait(current_tile, time_for_turn_seconds)


func are_moves_all_used() -> bool:
	return moves_remaining == 0


func handle_move_or_wait(tile: Tile, time_for_turn_seconds: float):
	if tile != null and tile != entity.occupancy.primary_tile:
		var was_move_succesful: bool = entity.occupancy.move_to_tile(tile)
		if was_move_succesful:
			is_movement_locked = true
			entity.occupancy.move_animation_completed.connect(_on_occupancy_move_animation_finished,
				CONNECT_ONE_SHOT)
	
	moves_remaining -= 1
	assert(moves_remaining >= 0, "Negative moves remaining.")
	
	if moves_remaining > 0:
		return
	
	modulate_to_next_turn(time_for_turn_seconds)
	scale_to_next_turn(time_for_turn_seconds)


func reset_moves_remaining():
	moves_remaining = data.moves_per_turn


func modulate_to_next_turn(time_for_turn_seconds):
	var time_between = time_for_turn_seconds - UNREADY_FADE_OUT_TIME_SECONDS - READY_FADE_IN_TIME_SECONDS
	var sprite: Sprite2D = entity.sprite
	
	var modulate_tween: Tween = entity.create_tween()
	modulate_tween.tween_property(sprite, "modulate:a",
		UNREADY_ALPHA, UNREADY_FADE_OUT_TIME_SECONDS)
	modulate_tween.tween_property(sprite, "modulate:a",
		UNREADY_ALPHA, time_between + EXTRA_FADE_DURATION_SECONDS)
	modulate_tween.tween_property(sprite, "modulate:a",
		1.0, READY_FADE_IN_TIME_SECONDS)


func scale_to_next_turn(time_for_turn_seconds):
	var sprite: Sprite2D = entity.sprite
	
	var stretch_tween: Tween = entity.create_tween()
	stretch_tween.tween_property(sprite, "scale", SQUISHED_SCALE, time_for_turn_seconds / 2.0)
	
	await stretch_tween.finished
	
	stretch_tween = entity.create_tween()
	stretch_tween.tween_property(sprite, "scale", DEFAULT_SCALE, time_for_turn_seconds / 2.0)


func _on_occupancy_move_animation_finished():
	is_movement_locked = false
