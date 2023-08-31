extends Node


var stats: Dictionary = {
	"runs_started": 0,
	"run_victories":  0,
	"enemies_killed": 0,
	"self_heals": 0
}


func _ready() -> void:
	GlobalSignals.run_started.connect(
		func ():
			augment_stat("runs_started", 1)
	)
	
	GlobalSignals.run_ended.connect(
		func (is_victory):
			if is_victory:
				augment_stat("run_victories", 1)
	)
	
	GlobalSignals.enemy_killed.connect(
		func (_enemy: Enemy):
			augment_stat("enemies_killed", 1)
	)
	
	GlobalSignals.player_healed.connect(
		func (_player: Player, amount: int):
			if amount > 0:
				augment_stat("self_heals", 1)
	)


func augment_stat(stat_name: String, amount: int):
	assert(stats.has(stat_name), "Trying to augment a stat that doesn't exist!")
	stats[stat_name] = stats[stat_name] + amount
