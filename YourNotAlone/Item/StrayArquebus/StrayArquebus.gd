extends "res://Item/Item.gd"

var damage_amount: int = 1
var bolt_count: int = 3
var range_radius: int = 2

onready var fire_particle_scene = preload("res://Data/Particles/FireParticles2.tscn")
# Tiers: 
#	1: 3 damage instances
#	2: 5 damage instances
#	3: 7 damage instances

func _ready():
	activation_style = ACTIVATION_STYLES.on_charge
	._ready()

func triggerTimer():
	pass
	#  .triggerTimer()  # Probably need to 

func upgradeTier() -> bool:
	var ret: bool = .upgradeTier()
	match currentTier:
		2:
			maxTurnTimer = 4
		3:
			maxTurnTimer = 5
	return ret

func activateItem() -> void:
	perform_attack()
	yield(get_tree(), "idle_frame")

func perform_attack() -> void:
	$AnimationPlayer.play("Shake")

func attack() -> void:
	pass