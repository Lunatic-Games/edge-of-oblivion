extends Control

var user
var turnTimer
var maxTurnTimer
var currentTier = 0
var maxTier = 3

onready var slashParticleScene = preload("res://SlashParticles.tscn")

func _ready():
	turnTimer = maxTurnTimer
	user = get_tree().get_nodes_in_group("player")[0]

func triggerTimer():
	turnTimer -= 1
	
	updateShaderParam()
	
	if turnTimer <= 0:
		activateItem()

func updateShaderParam():
	$Sprite.material.set_shader_param("progress", float(turnTimer-1)/float(maxTurnTimer-1))

func upgradeTier() -> bool:
	currentTier += 1
	if currentTier >= maxTier:
		return true
	
	return false

func activateItem():
	pass

func spawnSlashParticle(occupant):
	# Spawn attack slash
	var slashParticle = slashParticleScene.instance()
	slashParticle.position = user.currentTile.position
	if occupant.position < user.position:
		slashParticle.scale.x = slashParticle.scale.x * -1
	slashParticle.emitting = true
	get_tree().root.add_child(slashParticle)
