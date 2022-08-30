extends Control

var user
var turnTimer
var maxTurnTimer
var currentTier = 0
var maxTier = 3

func _ready():
	TurnManager.connect("playerTurnEnded", self, "triggerTimer")
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
