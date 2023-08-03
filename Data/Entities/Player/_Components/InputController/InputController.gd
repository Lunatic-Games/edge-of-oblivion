class_name InputController
extends Object


const DEFAULT_SCALE: Vector2 = Vector2(0.125, 0.125)
const SQUISHED_SCALE: Vector2 = Vector2(0.1, 0.1)
const UNREADY_FADE_OUT_TIME_SECONDS: float = 0.2
const UNREADY_ALPHA: float = 0.3
const READY_FADE_IN_TIME_SECONDS: float = 0.2

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
	
	
func handle_move_or_wait(tile: Tile):
	if tile != entity.occupancy.current_tile:
		entity.occupancy.move_to_tile(tile)
	
	moves_remaining -= 1
	assert(moves_remaining >= 0, "Negative moves remaining.")
	
	if moves_remaining > 0:
		return
	
	GlobalSignals.player_finished_moving.emit(self)
	move_modulate_tween()
	move_scale_tween()


func move_modulate_tween():
	var time_until_next_move: float = GlobalGameState.game.turn_manager.calculate_time_between_player_move()
	var time_between = time_until_next_move - UNREADY_FADE_OUT_TIME_SECONDS - READY_FADE_IN_TIME_SECONDS
	var sprite_material: Material = entity.sprite.material
	
	var modulate_tween: Tween = entity.create_tween()
	modulate_tween.tween_property(sprite_material, "shader_parameter/modulate:a",
		UNREADY_ALPHA, UNREADY_FADE_OUT_TIME_SECONDS)
	modulate_tween.tween_property(sprite_material, "shader_parameter/modulate:a",
		UNREADY_ALPHA, time_between)
	modulate_tween.tween_property(sprite_material, "shader_parameter/modulate:a",
		1.0, READY_FADE_IN_TIME_SECONDS)


func move_scale_tween():
	var time_until_next_move: float = GlobalGameState.game.turn_manager.calculate_time_between_player_move()
	var sprite: Sprite2D = entity.sprite
	
	var stretch_tween: Tween = entity.create_tween()
	stretch_tween.tween_property(sprite, "scale", SQUISHED_SCALE, time_until_next_move / 2.0)
	
	await stretch_tween.finished
	
	stretch_tween = entity.create_tween()
	stretch_tween.tween_property(sprite, "scale", DEFAULT_SCALE, time_until_next_move / 2.0)
