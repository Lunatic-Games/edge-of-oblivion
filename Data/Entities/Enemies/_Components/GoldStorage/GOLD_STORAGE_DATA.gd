class_name GoldStorageData
extends Resource


@export_range(0.0, 1.0) var chance_of_generating_gold: float = 1.0
@export_range(0, 100, 1, "or_greater") var min_gold_generated: int = 0
@export_range(0, 100, 1, "or_greater") var max_gold_generated: int = 0
@export var stores_collected_gold: bool = true
@export var add_particles_on_collecting_gold: bool = true


func generate_gold() -> int:
	if randf() > chance_of_generating_gold:
		return 0
	
	return randi_range(min_gold_generated, max_gold_generated)
