extends "res://Data/Units/Unit.gd"

signal itemReachedMaxTier
signal playerDied

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

onready var movesRemaining = moves
onready var item_container = $CanvasLayer/ItemContainer
onready var player_camera = $PlayerCamera
onready var experience_bar = $CanvasLayer/ExperienceBar
onready var canvas_tween = $CanvasLayer/CanvasTween


func _ready():
	var startingItems = [preload("res://Item/ShortSword/ShortSword.tres")]
	for item in startingItems:
		gainItem(item)

func _physics_process(delta):
	handleMovement()

func handleMovement():
	if !TurnManager.isPlayerTurn() or lock_movement or hp <= 0:
		return
	
	if (Input.is_action_just_pressed("up")):
		if(currentTile.topTile):
			move_to_tile(currentTile.topTile) # MovementUtility.moveDirection.up
	elif (Input.is_action_just_pressed("down")):
		if(currentTile.bottomTile):
			move_to_tile(currentTile.bottomTile)
	elif (Input.is_action_just_pressed("left")):
		if(currentTile.leftTile):
			move_to_tile(currentTile.leftTile)
	elif (Input.is_action_just_pressed("right")):
		if(currentTile.rightTile):
			move_to_tile(currentTile.rightTile)
	elif(Input.is_action_just_pressed("wait")):
		TurnManager.endPlayerTurn()


func move_to_tile(tile, move_precedence: float = 0.0) -> void:
	.move_to_tile(tile)
	
	movesRemaining -= 1
	if movesRemaining <= 0:
		TurnManager.endPlayerTurn()
		movesRemaining = moves

func die():
	self.remove_child(player_camera)
	GameManager.gameboard.add_child(player_camera)
	player_camera.set_owner(GameManager.gameboard)
	tween.interpolate_property(player_camera, "global_position", global_position, currentTile.global_position, 1.0)
	tween.start()
	emit_signal("playerDied")
	.die()

func gainExperience(experience):
	if currentLevel >= levelThresholds.size():
		return
	
	currentXp += experience
	
	if currentXp >= levelThresholds[currentLevel]:
		levelUp()
	else:
		update_experience_bar()

func levelUp():
	FreeUpgradeMenu.spawnUpgradeCards(3)
	update_experience_bar()
	currentLevel += 1
	currentXp = 0
	yield(get_tree().create_timer(experience_bar_update_time), "timeout")
	experience_bar.emit_particle()
	update_experience_bar()
	
	

func gainItem(itemData):
	if itemData in items:
		ItemManager.upgradeItem(itemData)
	else:
		items.append(itemData)
		ItemManager.addItem(itemData)

func isEnemy():
	return false

func update_experience_bar() -> void:
	experience_bar.max_value = levelThresholds[currentLevel]
	canvas_tween.interpolate_property(experience_bar, "value", experience_bar.value, currentXp, experience_bar_update_time)
	canvas_tween.start()
	yield(canvas_tween, "tween_all_completed")
