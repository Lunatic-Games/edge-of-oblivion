extends "res://Data/Units/Unit.gd"

signal item_reached_max_tier
signal died

const STARTING_ITEMS = [preload("res://Items/ShortSword/ShortSword.tres")]

var experience_bar_update_time = 0.2
var moves = 1
var currentXp = 0
var currentLevel = 1
var levelThresholds = {
	1:1,
	2:3,
	3:3,
	4:4,
	5:5,
	6:5,
	7:5,
	8:5,
	9:5,
	10:5
}
var items = []

@onready var movesRemaining = moves
@onready var item_container = $CanvasLayer/ItemContainer
@onready var player_camera = $PlayerCamera
@onready var experience_bar = $CanvasLayer/ExperienceBar


func _ready() -> void:
	super._ready()
	for item in STARTING_ITEMS:
		gain_item(item)


func _physics_process(_delta: float) -> void:
	handle_movement()


func handle_movement():
	if !TurnManager.is_player_turn() or lock_movement or hp <= 0:
		return
	
	if Input.is_action_just_pressed("up") and current_tile.top_tile:
		move_history.record(MovementUtility.MoveRecord.new(current_tile, current_tile.top_tile, "up", "handle_movement"))
		move_to_tile(current_tile.top_tile) # MovementUtility.moveDirection.up
	elif Input.is_action_just_pressed("down") and current_tile.bottom_tile:
		move_history.record(MovementUtility.MoveRecord.new(current_tile, current_tile.bottom_tile, "down", "handle_movement"))
		move_to_tile(current_tile.bottom_tile)
	elif Input.is_action_just_pressed("left") and current_tile.left_tile:
		move_history.record(MovementUtility.MoveRecord.new(current_tile, current_tile.left_tile, "left", "handle_movement"))
		move_to_tile(current_tile.left_tile)
	elif Input.is_action_just_pressed("right") and current_tile.right_tile:
		move_history.record(MovementUtility.MoveRecord.new(current_tile, current_tile.right_tile, "right", "handle_movement"))
		move_to_tile(current_tile.right_tile)
	elif Input.is_action_just_pressed("wait"):
		TurnManager.end_player_turn()


func move_to_tile(tile) -> void:
	super.move_to_tile(tile)
	
	movesRemaining -= 1
	if movesRemaining <= 0:
		TurnManager.end_player_turn()
		movesRemaining = moves

func die():
	var camera_position_before = player_camera.global_position
	
	self.remove_child(player_camera)
	GameManager.gameboard.add_child(player_camera)
	player_camera.set_owner(GameManager.gameboard)
	
	player_camera.global_position = camera_position_before
	
	emit_signal("died")
	super.die()

func gain_experience(experience):
	if currentLevel >= levelThresholds.size():
		return
	
	currentXp += experience
	
	if currentXp >= levelThresholds[currentLevel]:
		level_up()
	else:
		update_experience_bar()


func level_up():
	FreeUpgradeMenu.spawn_upgrade_cards(3)
	update_experience_bar()
	currentLevel += 1
	currentXp = 0
	await get_tree().create_timer(experience_bar_update_time).timeout
	experience_bar.emit_particle()
	update_experience_bar()


func gain_item(item_data):
	if item_data in items:
		ItemManager.upgrade_item(item_data)
	else:
		items.append(item_data)
		ItemManager.add_item(item_data)


func is_enemy():
	return false


func update_experience_bar() -> void:
	experience_bar.max_value = levelThresholds[currentLevel]
	
	var tween = get_tree().create_tween()
	tween.tween_property(experience_bar, "value", currentXp, experience_bar_update_time)
	await tween.finished
