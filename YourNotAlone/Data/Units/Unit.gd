extends "res://occupant.gd"

var lock_movement = false
var currentTile
var maxHp = 3

onready var hp = maxHp
onready var animation_player = $AnimationPlayer
onready var health_bar = $HealthBar
onready var tween = $Tween
onready var sprite = $Sprite

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
	
	if self.is_in_group("player") && tile.occupied && tile.occupied.occupantType == tile.occupied.occupantTypes.collectable:
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
