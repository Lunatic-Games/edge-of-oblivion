class_name Player
extends "res://Data/Units/Unit.gd"

signal item_reached_max_tier

const STARTING_ITEMS = [preload("res://Data/Items/ShortSword/ShortSword.tres")]

var experience_bar_update_time: float = 0.2
var moves: int = 1
var moves_remaining: int = moves
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
var items: Array[ItemData] = []

@onready var item_container: BoxContainer = $CanvasLayer/ItemContainer
@onready var player_camera: Camera2D = $PlayerCamera
@onready var experience_bar: ProgressBar = $CanvasLayer/ExperienceBar


func _physics_process(_delta: float) -> void:
	handle_movement()


func handle_movement() -> void:
	if !TurnManager.is_player_turn() or lock_movement or hp <= 0:
		return
	
	if  FreeUpgradeMenu.is_currently_picking_item:
		return
	
	if Input.is_action_just_pressed("up") and current_tile.top_tile:
		move_history.record(MovementUtility.MoveRecord.new(current_tile, current_tile.top_tile,
			Vector2i.UP, MovementUtility.CauseOfMove.INPUT))
		move_to_tile(current_tile.top_tile)
	
	elif Input.is_action_just_pressed("down") and current_tile.bottom_tile:
		move_history.record(MovementUtility.MoveRecord.new(current_tile, current_tile.bottom_tile,
			Vector2i.DOWN, MovementUtility.CauseOfMove.INPUT))
		move_to_tile(current_tile.bottom_tile)
	
	elif Input.is_action_just_pressed("left") and current_tile.left_tile:
		move_history.record(MovementUtility.MoveRecord.new(current_tile, current_tile.left_tile,
			Vector2i.LEFT, MovementUtility.CauseOfMove.INPUT))
		move_to_tile(current_tile.left_tile)
	
	elif Input.is_action_just_pressed("right") and current_tile.right_tile:
		move_history.record(MovementUtility.MoveRecord.new(current_tile, current_tile.right_tile,
			Vector2i.RIGHT, MovementUtility.CauseOfMove.INPUT))
		move_to_tile(current_tile.right_tile)
	
	elif Input.is_action_just_pressed("wait"):
		TurnManager.end_player_turn()


func add_starting_items() -> void:
	for item in STARTING_ITEMS:
		gain_item(item, false)


func move_to_tile(tile: Tile) -> void:
	super.move_to_tile(tile)
	
	moves_remaining -= 1
	if moves_remaining <= 0:
		TurnManager.end_player_turn()
		moves_remaining = moves


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
	FreeUpgradeMenu.spawn_upgrade_cards(3)
	update_experience_bar()
	current_level += 1
	current_xp = 0
	await get_tree().create_timer(experience_bar_update_time).timeout
	experience_bar.emit_particle()
	update_experience_bar()


func gain_item(item_data: ItemData, animate: bool = true) -> void:
	if item_data in items:
		ItemManager.upgrade_item(item_data)
	else:
		items.append(item_data)
		ItemManager.add_item(item_data, animate)


func is_enemy() -> bool:
	return false


func update_experience_bar() -> void:
	experience_bar.max_value = level_thresholds[current_level]
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(experience_bar, "value", current_xp, experience_bar_update_time)
	await tween.finished
