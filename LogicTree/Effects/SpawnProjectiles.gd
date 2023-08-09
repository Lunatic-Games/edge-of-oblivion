@icon("res://Assets/art/logic-tree/effects/spawn.png")
class_name LT_SpawnProjectiles
extends LogicTreeEffect


@export var origin_tiles: LT_TileArrayVariable
@export var target_tiles: LT_TileArrayVariable
@export var projectile_scene: PackedScene = null
@export_range(0.001, 0.5, 0.001) var seconds_per_tile_speed: float = 0.08
@export var rotate_to_direction: bool = true


func _ready() -> void:
	assert(origin_tiles != null, "Origin tiles not set for '" + name + "'")
	assert(target_tiles != null, "Target tiles not set for '" + name + "'")
	assert(projectile_scene != null, "Projectile scene not set for '" + name + "'")


func perform_behavior() -> void:
	var board: Board = GlobalGameState.get_board()
	
	for origin_tile in origin_tiles.value:
		for target_tile in target_tiles.value:
			var projectile: Projectile = projectile_scene.instantiate() as Projectile
			assert(projectile != null, "Failed to instaniate packed scene as a Projectile for '" + name + "'")
			board.add_child(projectile)
			
			projectile.global_position = origin_tile.global_position
			projectile.setup(origin_tile, target_tile, seconds_per_tile_speed)
			
			if rotate_to_direction:
				var target_pos: Vector2 = target_tile.global_position
				var origin_pos: Vector2 = origin_tile.global_position
				projectile.rotation = origin_pos.angle_to_point(target_pos)
