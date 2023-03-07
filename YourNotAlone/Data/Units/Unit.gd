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
onready var health_particle_scene = preload("res://Data/Particles/HealthParticles.tscn")

onready var particles: Dictionary = {
	"damage": damaged_particle_scene,
	"health": health_particle_scene
}

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
	spawn_particle("damage")
	animation_player.play("damaged")
	
	if hp <= 0:
		die()

func heal(heal_amount) -> int:
	spawn_particle("health")
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

func spawn_particle(type: String):
	var res = particles[type]
	var particle = res.instance()
	particle.global_position = self.global_position
	GameManager.gameboard.add_child(particle)

func die():
	currentTile.clearOccupant()
	tween.interpolate_property(self, "global_position", global_position, global_position + Vector2(0, -25), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(self, "modulate", modulate, modulate * Color(1, 1, 1, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
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
