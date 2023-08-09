class_name LevelData
extends Resource


enum GatewaySpawnCondition {
	#NO_GATEWAY,
	#BOSS_DEFEATED,
	#DEFEATED_ALL_WAVES,
	ON_LOAD
}

@export_placeholder("Level name") var level_name: String
@export var level_scene: PackedScene = null
@export var level_waves: LevelWaves = null
@export var next_level: LevelData = null
@export var game_mode: GameModeData = preload("res://Data/GameModes/Standard/Standard.tres")
@export var gateway_spawn_condition: GatewaySpawnCondition = GatewaySpawnCondition.ON_LOAD
