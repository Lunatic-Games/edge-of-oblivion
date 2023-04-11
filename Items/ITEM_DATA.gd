class_name ItemData
extends Resource

@export var sprite: Texture2D
@export var item_scene: PackedScene
@export var item_name: String
@export var tier1Text: String
@export var tier2Text: String
@export var tier3Text: String
@export_range(0, 999, 1, "or_greater") var max_turn_timer: int = 3
@export_range(0, 999, 1, "or_greater") var item_damage: int = 1
@export var path: String
