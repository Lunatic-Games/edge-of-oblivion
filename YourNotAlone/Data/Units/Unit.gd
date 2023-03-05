class_name Unit
extends "res://Occupant.gd"

var lock_movement = false
var currentTile
var max_hp = 3
var canFall = true
var hp

onready var animation_player = $AnimationPlayer
onready var health_bar = $HealthBar
onready var tween = $Tween
onready var sprite = $Sprite
onready var damaged_particle_scene = preload("res://Data/Particles/DamagedParticles.tscn")

func _ready():
	hp = max_hp

func setup():
	animation_player.play("spawn")
	yield(animation_player, "animation_finished")

func isEnemy():
	pass

func takeDamage(damageTaken):
	if damageTaken == 0:
		return
	
	hp -= damageTaken
	update_health_bar()
	spawn_damage_particle()
	animation_player.play("damaged")
	
	if hp <= 0:
		die()

func heal(heal_amount) -> int:
	if hp < max_hp:
		hp += heal_amount
		update_health_bar()
		if hp > max_hp:
			var extra: int = hp - max_hp
			hp = max_hp
			return extra
		return 0
	else:
		return heal_amount

func update_health_bar():
	health_bar.value = float(hp)/float(max_hp) * 100
	tween.interpolate_property(health_bar, "value", health_bar.value, float(hp)/float(max_hp) * 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func spawn_damage_particle():
	var particle = damaged_particle_scene.instance()
	particle.global_position = self.global_position
	GameManager.gameboard.add_child(particle)

func die():
	currentTile.clearOccupant()
	queue_free()

func fall():
	if canFall:
		die()
	else:
		# Handle cases like bosses where unit can't fall
		pass

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
