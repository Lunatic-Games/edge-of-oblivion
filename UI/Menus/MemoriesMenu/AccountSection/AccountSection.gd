extends VBoxContainer


const STAT_LABEL_SCENE: PackedScene = preload("res://UI/Menus/MemoriesMenu/AccountSection/StatLabel.tscn")

@onready var account_level_label: Label = $AccountSummary/AccountLevel/LevelLabel
@onready var account_level_bar: ProgressBar = $AccountSummary/ProgressBar
@onready var account_level_bar_label: Label = $AccountSummary/ProgressBar/Label

@onready var left_stat_column: BoxContainer = $StatsSummary/Columns/LeftColumn
@onready var right_stat_column: BoxContainer = $StatsSummary/Columns/RightColumn


func _ready() -> void:
	account_level_label.text = str(GlobalAccount.level)
	if GlobalAccount.is_max_level():
		account_level_bar.value = account_level_bar.max_value
		account_level_bar_label.text = "MAX LEVEL"
	else:
		var xp: int = GlobalAccount.xp
		var out_of: int = GlobalAccount.get_total_xp_cost_of_next_level()
		var ratio: float = float(xp) / float(out_of)
		account_level_bar.value = ratio * account_level_bar.max_value
		account_level_bar_label.text = str(xp) + "XP / " + str(out_of) + "XP"
	
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
