class_name EntityData
extends Resource


@export var entity_scene: PackedScene
@export var health_data: HealthData
@export var occupancy_data: OccupancyData

@export_group("Info")
@export var sprite: Texture = null
@export var entity_name: String = ""
@export_multiline var main_text: String = ""
@export_multiline var flavor_text: String = ""


func get_full_main_text():
	return "[color=cyan]" + entity_name + ":[/color] " + main_text
