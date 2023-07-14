extends Node


@onready var main_menu_music_player: MusicPlayer = $MainMenuMusic
@onready var battle_music_player: MusicPlayer = $BattleMusic
@onready var boss_music_player: MusicPlayer = $BossMusic


func _ready() -> void:
	GlobalSignals.main_menu_entered.connect(_on_main_menu_loaded)
	GlobalSignals.run_started.connect(_on_run_started)
	GlobalSignals.boss_spawned.connect(_on_boss_spawned)
	GlobalSignals.boss_defeated.connect(_on_boss_defeated)


func _on_main_menu_loaded() -> void:
	boss_music_player.fade_out_volume()
	battle_music_player.fade_out_volume()
	main_menu_music_player.start_new_random_track(true)


func _on_run_started() -> void:
	boss_music_player.fade_out_volume()
	main_menu_music_player.fade_out_volume()
	battle_music_player.start_new_random_track(true)


func _on_boss_spawned(boss: Boss) -> void:
	assert(boss.sound_track != null, "Boss does not have a soundtrack!")
	
	battle_music_player.fade_out_volume()
	boss_music_player.tracks = [boss.sound_track]
	boss_music_player.start_new_random_track(true)


func _on_boss_defeated(_boss: Boss) -> void:
	boss_music_player.fade_out_volume()
	battle_music_player.start_new_random_track(true)
