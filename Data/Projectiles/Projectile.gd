class_name Projectile
extends Node2D


func setup(starting_tile: Tile, target_tile: Tile, seconds_per_tile_speed: float) -> void:
	var distance: int = starting_tile.get_manhattan_coord_distance_to_given_tile(target_tile)
	
	var position_tween: Tween = create_tween()
	position_tween.tween_property(self, "global_position", target_tile.global_position,
		distance * seconds_per_tile_speed).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	await position_tween.finished
	
	var modulate_tween: Tween = create_tween()
	modulate_tween.tween_property(self, "modulate:a", 0.0, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await modulate_tween.finished
