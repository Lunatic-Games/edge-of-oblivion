class_name WaveData
extends Resource


enum BossSpawn {
	NONE,
	FORGOTTEN_KING
}

const FADED_SCENE: PackedScene = preload("res://Data/Units/Enemies/Faded/Faded.tscn")
const RANGER_SCENE: PackedScene = preload("res://Data/Units/Enemies/LostRanger/LostRanger.tscn")
const PIKE_SCENE: PackedScene = preload("res://Data/Units/Enemies/ForswornPike/ForswornPike.tscn")
const FORGOTTEN_KING_SCENE: PackedScene = preload("res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn")

@export_range(1, 99, 1, "or_greater") var turn_wait_from_previous_wave: int = 1
@export_range(0, 99) var n_faded: int
@export_range(0, 99) var n_rangers: int
@export_range(0, 99) var n_pikes: int
@export var boss: BossSpawn


func get_enemies_for_wave() -> Array[PackedScene]:
	var enemies: Array[PackedScene] = []

	for i in n_faded:
		enemies.append(FADED_SCENE)
	for i in n_rangers:
		enemies.append(RANGER_SCENE)
	for i in n_pikes:
		enemies.append(PIKE_SCENE)

	match boss:
		BossSpawn.FORGOTTEN_KING:
			enemies.append(FORGOTTEN_KING_SCENE)

	return enemies
