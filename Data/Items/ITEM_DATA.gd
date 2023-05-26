class_name ItemData
extends Resource

@export var sprite: Texture2D = null
@export var item_scene: PackedScene = null
@export_placeholder("Item Name") var item_name: String = ""
@export_multiline var tier1Text: String = ""
@export_multiline var tier2Text: String = ""
@export_multiline var tier3Text: String = ""
@export_multiline var flavor_text: String = ""
@export_range(0, 999, 1, "or_greater") var max_turn_timer: int = 3
@export_range(0, 999, 1, "or_greater") var item_damage: int = 1
