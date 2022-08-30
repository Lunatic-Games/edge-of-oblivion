extends Node2D

signal itemReachedMaxTier

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

onready var movesRemaining = moveSpeed
onready var hp = maxHp
onready var ItemManager = $CanvasLayer/ItemManager

func _ready():
	var startingItems = [preload("res://ItemData/Gladius.tres")]
	for item in startingItems:
		gainItem(item)

func _physics_process(delta):
	handleMovement()

func handleMovement():
	if !TurnManager.isPlayerTurn():
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
	position = tile.position
	MovementUtility.lastPlayerDirection = moveDirection
	
	movesRemaining -= 1
	if movesRemaining <= 0:
		TurnManager.endPlayerTurn()
		movesRemaining = moveSpeed

func takeDamage(damage):
	hp -= 1
	updateShaderParam()
	
	if hp <= 0:
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

func updateShaderParam():
	$Sprite.material.set_shader_param("progress", 1 - float(hp)/float(maxHp))

func gainItem(itemData):
	if itemData in items:
		ItemManager.upgradeItem(itemData)
	else:
		items.append(itemData)
		ItemManager.addItem(itemData)

func isEnemy():
	return false
