extends "res://occupant.gd"

var currentTile
var maxHp = 3

onready var hp = maxHp
onready var animation_player = $AnimationPlayer
onready var health_bar = $HealthBar
onready var tween = $Tween

func setup():
	animation_player.play("spawn")
	yield(animation_player, "animation_finished")

func isEnemy():
	pass

func takeDamage(damageTaken):
	hp -= damageTaken
	update_health_bar()
	
	if hp <= 0:
		die()

func update_health_bar():
	health_bar.value = float(hp)/float(maxHp) * 100
	tween.interpolate_property(health_bar, "value", health_bar.value, float(hp)/float(maxHp) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func die():
	currentTile.occupied = null
	queue_free()

func is_alive():
	if hp > 0:
		return true
	return false

func moveToTile(tile):
	if tile.occupied && tile.occupied.occupantType == tile.occupied.occupantTypes.blocking:
		return
	
	if tile.occupied && tile.occupied.occupantType == tile.occupied.occupantTypes.collectable: # PLAYER
		#tile.occupied.collect()
		pass
	
	GameManager.unoccupyTile(currentTile)
	GameManager.occupyTile(tile, self)
	currentTile = tile
	position = tile.position
