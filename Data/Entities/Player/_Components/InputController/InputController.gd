class_name InputController
extends Object


const DEFAULT_SCALE: Vector2 = Vector2(0.125, 0.125)
const SQUISHED_SCALE: Vector2 = Vector2(0.1, 0.1)
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


func check_for_input():
	if !entity.health.is_alive() or GlobalGameState.game_ended or GlobalGameState.in_upgrade_menu:
		return
	
	if moves_remaining == 0 or is_movement_locked:
		return
	
	var current_tile: Tile = entity.occupancy.current_tile
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


func are_moves_all_used() -> bool:
	return moves_remaining == 0


func handle_move_or_wait(tile: Tile):
	if tile != entity.occupancy.current_tile:
		var was_move_succesful: bool = entity.occupancy.move_to_tile(tile)
		if was_move_succesful:
			is_movement_locked = true
			entity.occupancy.move_animation_completed.connect(_on_occupancy_move_animation_finished,
				CONNECT_ONE_SHOT)
	
	moves_remaining -= 1
	assert(moves_remaining >= 0, "Negative moves remaining.")
	
	if moves_remaining > 0:
		return
	
	modulate_to_next_turn()
	scale_to_next_turn()


func reset_moves_remaining():
	moves_remaining = data.moves_per_turn


func modulate_to_next_turn():
	var time_until_next_move: float = TurnManager.calculate_time_between_player_move()
	var time_between = time_until_next_move - UNREADY_FADE_OUT_TIME_SECONDS - READY_FADE_IN_TIME_SECONDS
	var sprite: Sprite2D = entity.sprite
	
	var modulate_tween: Tween = entity.create_tween()
	modulate_tween.tween_property(sprite, "modulate:a",
		UNREADY_ALPHA, UNREADY_FADE_OUT_TIME_SECONDS)
	modulate_tween.tween_property(sprite, "modulate:a",
		UNREADY_ALPHA, time_between + EXTRA_FADE_DURATION_SECONDS)
	modulate_tween.tween_property(sprite, "modulate:a",
		1.0, READY_FADE_IN_TIME_SECONDS)


func scale_to_next_turn():
	var time_until_next_move: float = TurnManager.calculate_time_between_player_move()
	var sprite: Sprite2D = entity.sprite
	
	var stretch_tween: Tween = entity.create_tween()
	stretch_tween.tween_property(sprite, "scale", SQUISHED_SCALE, time_until_next_move / 2.0)
	
	await stretch_tween.finished
	
	stretch_tween = entity.create_tween()
	stretch_tween.tween_property(sprite, "scale", DEFAULT_SCALE, time_until_next_move / 2.0)


func _on_occupancy_move_animation_finished():
	is_movement_locked = false
