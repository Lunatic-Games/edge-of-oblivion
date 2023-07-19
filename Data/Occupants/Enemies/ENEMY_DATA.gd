class_name EnemyData
extends Resource


@export var enemy_name: String
@export var sprite: Texture2D = null
@export var enemy_scene: PackedScene = null
@export var xp_value: int = 5
@export var is_boss: bool = false
@export var boss_soundtrack: AudioStream = null
@export_multiline var popup_text: String = ""
@export_multiline var flavor_text: String = ""


func get_full_popup_text() -> String:
	return "[color=cyan]" + enemy_name + ":[/color] " + popup_text
