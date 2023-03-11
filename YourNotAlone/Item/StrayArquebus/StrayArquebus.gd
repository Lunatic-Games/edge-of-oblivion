extends "res://Item/Item.gd"

var damage_amount: int = 1

onready var fire_particle_scene = preload("res://Data/Particles/FireParticles2.tscn")
# Tiers: 
#	1: 3 max charges
#	2: 4 max charges
#	3: 5 max charges

func _ready():
	activation_style = ACTIVATION_STYLES.on_charge
	._ready()

# Returns true if item activated
func activate_on_charge() -> bool:
	# Roll chance
	var chance_to_activate: float = float(maxTurnTimer - turnTimer) / maxTurnTimer
	var roll = randf()
	#print(chance_to_activate, roll)
	if roll < chance_to_activate:
		#print("passed roll")
		clear_timer_activate()
		return true
	#print("Failed roll")
	return false
	
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