extends Node2D

var seconds_per_tile = 0.08

onready var tween = $Tween

signal effect_complete

func setup(starting_tile:Tile, target_tile:Tile):
	var distance:int = starting_tile.get_distance_to_tile(target_tile)
	tween.interpolate_property(self, "global_position", global_position, target_tile.global_position, distance*seconds_per_tile, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("effect_complete")
	tween.interpolate_property(self, "modulate", modulate, modulate * Color(1,1,1,0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
