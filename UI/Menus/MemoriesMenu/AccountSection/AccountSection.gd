extends VBoxContainer


const STAT_LABEL_SCENE: PackedScene = preload("res://UI/Menus/MemoriesMenu/AccountSection/StatLabel.tscn")

@onready var left_stat_column: BoxContainer = $StatsSummary/Columns/LeftColumn
@onready var right_stat_column: BoxContainer = $StatsSummary/Columns/RightColumn


func _ready() -> void:
	var enemies_killed: int = GlobalAccountStatTracker.stats["enemies_killed"]
	var self_heals: int = GlobalAccountStatTracker.stats["self_heals"]
	var runs_started: int = GlobalAccountStatTracker.stats["runs_started"]
	var run_victories: int = GlobalAccountStatTracker.stats["run_victories"]
	
	var left_stats: Array[String] = [
		"Enemies killed: " + str(enemies_killed),
		"Self heals: " + str(self_heals)
	]
	
	var right_stats: Array[String] = [
		"Runs started: " + str(runs_started),
		"Run victories: " + str(run_victories)
	]
	
	for stat in left_stats:
		var stat_label: Label = STAT_LABEL_SCENE.instantiate()
		stat_label.text = stat
		left_stat_column.add_child(stat_label)
	
	for stat in right_stats:
		var stat_label: Label = STAT_LABEL_SCENE.instantiate()
		stat_label.text = stat
		right_stat_column.add_child(stat_label)
