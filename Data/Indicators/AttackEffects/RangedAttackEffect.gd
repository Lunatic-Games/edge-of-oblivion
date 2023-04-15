extends Node2D

signal effect_completed

var seconds_per_tile: float = 0.08


func setup(starting_tile: Tile, target_tile: Tile) -> void:
	var distance: int = starting_tile.get_distance_to_tile(target_tile)
	
	var position_tween: Tween = get_tree().create_tween()
	position_tween.tween_property(self, "global_position", target_tile.global_position, distance * seconds_per_tile).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	await position_tween.finished
	
	effect_completed.emit()
	
	var modulate_tween: Tween = get_tree().create_tween()
	modulate_tween.tween_property(self, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await modulate_tween.finished
