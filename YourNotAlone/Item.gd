extends Control

var user
var turnTimer
var maxTurnTimer
var currentTier = 0
var maxTier = 3

onready var slashParticleScene = preload("res://SlashParticles.tscn")
onready var cooldown_bar = $CoolDownBar

func _ready():
	turnTimer = maxTurnTimer
	user = get_tree().get_nodes_in_group("player")[0]

func triggerTimer():
	turnTimer -= 1
	
	update_cool_down_bar()
	
	if turnTimer == 1:
		return true
	
	if turnTimer <= 0:
		activateItem()
	
	return false

func update_cool_down_bar():
	cooldown_bar.value = (1 - float(turnTimer-1)/float(maxTurnTimer-1)) * 100

func upgradeTier() -> bool:
	currentTier += 1
	if currentTier >= maxTier:
		return true
	
	return false

func activateItem():
	pass

func spawnSlashParticle(positionToSpawn):
	# Spawn attack slash
	var slashParticle = slashParticleScene.instance()
	slashParticle.position = user.currentTile.position
	if positionToSpawn.position < user.position:
		slashParticle.scale.x = slashParticle.scale.x * -1
	slashParticle.emitting = true
	get_tree().root.add_child(slashParticle)

func spawnLightningParticle(positionToSpawn):
	# Spawn attack slash
	var slashParticle = slashParticleScene.instance()
	slashParticle.position = positionToSpawn.position
	slashParticle.emitting = true
	get_tree().root.add_child(slashParticle)
