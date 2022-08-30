extends "res://Item.gd"

# Tiers
# 1 - Attack left space
# 2 - Attack right space also
# 3 - Attacks two turns in a row

var itemDamage = 1

onready var slashParticleScene = preload("res://SlashParticles.tscn")

func _ready():
	maxTurnTimer = 3
	turnTimer = maxTurnTimer

func triggerTimer():
	turnTimer -= 1
	updateShaderParam()
	
	if currentTier == 3 && turnTimer == maxTurnTimer-1:
		performAttack()
	
	if turnTimer <= 0:
		activateItem()

func activateItem():
	performAttack()
	turnTimer = maxTurnTimer
	updateShaderParam()

func performAttack():
	var leftTile = user.currentTile.leftTile
	var rightTile = user.currentTile.rightTile
	
	if(leftTile && leftTile.occupied && leftTile.occupied.isEnemy()):
		attack(leftTile.occupied)
	
	if (currentTier >= 2 && rightTile && rightTile.occupied && rightTile.occupied.isEnemy()):
		attack(rightTile.occupied)
	
	$AnimationPlayer.play("Shake")

func attack(occupant):
	# Spawn attack slash
	var slashParticle = slashParticleScene.instance()
	slashParticle.position = user.currentTile.position
	if occupant.position < user.position:
		slashParticle.scale.x = slashParticle.scale.x * -1
	slashParticle.emitting = true
	get_tree().root.add_child(slashParticle)
	occupant.takeDamage(itemDamage)
