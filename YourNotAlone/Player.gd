extends Node2D

signal itemReachedMaxTier
signal playerDied

var currentTile
var moveSpeed = 1
var maxHp = 3
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
var lock_movement = false

onready var movesRemaining = moveSpeed
onready var hp = maxHp
onready var ItemManager = $CanvasLayer/ItemManager
onready var tween = $Tween
onready var sprite = $Sprite
onready var health_bar = $HealthBar
onready var animation_player = $AnimationPlayer

func _ready():
	var startingItems = [preload("res://Item/ShortSword/ShortSword.tres")]
	for item in startingItems:
		gainItem(item)

func _physics_process(delta):
	handleMovement()

func handleMovement():
	if !TurnManager.isPlayerTurn() or lock_movement:
		return
	
	if (Input.is_action_just_pressed("up")):
		if(currentTile.topTile):
			moveToTile(currentTile.topTile, MovementUtility.moveDirection.up)
	
	if (Input.is_action_just_pressed("down")):
		if(currentTile.bottomTile):
			moveToTile(currentTile.bottomTile, MovementUtility.moveDirection.down)
	
	if (Input.is_action_just_pressed("left")):
		if(currentTile.leftTile):
			moveToTile(currentTile.leftTile, MovementUtility.moveDirection.left)
	
	if (Input.is_action_just_pressed("right")):
		if(currentTile.rightTile):
			moveToTile(currentTile.rightTile, MovementUtility.moveDirection.right)
	
	if (Input.is_action_just_pressed("levelUpCheat")):
		levelUp()

func moveToTile(tile, moveDirection):
	if tile.occupied && tile.occupied.occupantType == tile.occupied.occupantTypes.blocking:
		return
	
	if tile.occupied && tile.occupied.occupantType == tile.occupied.occupantTypes.collectable:
		tile.occupied.collect()
	
	
	
	GameManager.unoccupyTile(currentTile)
	GameManager.occupyTile(tile, self)
	currentTile = tile
	lock_movement = true
	tween.interpolate_property(self, "position", position, tile.position, 0.20, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "position", sprite.position, sprite.position + Vector2(0.0, -15.0), 0.10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "position", sprite.position + Vector2(0.0, -15.0), sprite.position, 0.10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.1)
	tween.start()
	yield(tween, "tween_all_completed")
	lock_movement = false
	MovementUtility.lastPlayerDirection = moveDirection
	
	movesRemaining -= 1
	if movesRemaining <= 0:
		TurnManager.endPlayerTurn()
		movesRemaining = moveSpeed

func takeDamage(damage):
	hp -= 1
	update_health_bar()
	
	if hp <= 0:
		emit_signal("playerDied")
		print("GameOver")

func gainExperience(experience):
	if currentLevel >= levelThresholds.size():
		return
	
	currentXp += experience
	
	if currentXp >= levelThresholds[currentLevel]:
		levelUp()

func levelUp():
	GameManager.spawnChest()
	currentLevel += 1
	currentXp = 0

func update_health_bar():
	health_bar.value = float(hp)/float(maxHp) * 100
	tween.interpolate_property(health_bar, "value", health_bar.value, float(hp)/float(maxHp) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func gainItem(itemData):
	if itemData in items:
		ItemManager.upgradeItem(itemData)
	else:
		items.append(itemData)
		ItemManager.addItem(itemData)

func isEnemy():
	return false
