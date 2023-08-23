class_name LevelData
extends Resource


enum GatewaySpawnCondition {
	NEVER,
	BOSS_DEFEATED,
	LAST_WAVE_SPAWNED,
	ON_LOAD
}

@export_placeholder("Level name") var level_name: String
@export var level_scene: PackedScene = null
@export var level_waves: LevelWaves = null
@export var next_level: LevelData = null
@export var game_mode: GameModeData = preload("res://Data/GameModes/Standard/Standard.tres")
@export var gateway_spawn_condition: GatewaySpawnCondition = GatewaySpawnCondition.NEVER
@export var killing_boss_completes_run: bool = false

# See Player.gd PersistenceSettings
@export_flags("Health", "Items", "Gold", "XP") var player_persistence: int = 15
