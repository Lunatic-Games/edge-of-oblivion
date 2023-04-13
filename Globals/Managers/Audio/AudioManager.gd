extends Node2D

enum MusicState {
	MENU,
	BATTLE,
	BOSS
}

var menu_music: Array[AudioStream] = [
	preload("res://Assets/music/menu/Fall-From-Grace.mp3"),
	preload("res://Assets/music/menu/Lurking-Evil.mp3")
]

var battle_music: Array[AudioStream] = [
	preload("res://Assets/music/battle/chase.mp3"),
	preload("res://Assets/music/battle/Dragon-Castle.mp3"),
	preload("res://Assets/music/battle/Dragon-World.mp3"),
	preload("res://Assets/music/battle/Durandal.mp3"),
	preload("res://Assets/music/battle/Hitman.mp3"),
	preload("res://Assets/music/battle/Hostiles-Inbound.mp3"),
	preload("res://Assets/music/battle/The-Torch-Of-Knowledge.mp3")
]

var current_MusicState: MusicState = MusicState.MENU

@onready var battle_player: AudioStreamPlayer = $BattleMusicPlayer
@onready var menu_player: AudioStreamPlayer = $MenuMusicPlayer
@onready var boss_player: AudioStreamPlayer = $BossMusicPlayer


func _ready() -> void:
	battle_player.finished.connect(queue_battle_music)
	GameManager.main_menu_loaded.connect(start_menu_music)
	
	GlobalSignals.game_started.connect(start_game_audio)
	GlobalSignals.boss_spawned.connect(_on_Boss_spawned)
	GlobalSignals.boss_defeated.connect(_on_Boss_defeated)
	start_menu_music()


func queue_battle_music() -> void:
	fade_out(menu_player, 2.0)
	battle_player.stream = battle_music[randi()%battle_music.size()]
	fade_in(battle_player, 1.1)
	battle_player.play()


func queue_menu_music() -> void:
	fade_out(battle_player, 1.0)
	fade_out(boss_player, 1.0)
	menu_player.stream = menu_music[randi()%menu_music.size()]
	fade_in(menu_player, 2.0)
	menu_player.play()


func queue_boss_music(boss_music) -> void:
	fade_out(battle_player, 2.0)
	boss_player.stream = boss_music
	fade_in(boss_player, 1.0)
	boss_player.play()


func start_game_audio() -> void:
	stop_boss_music()


func start_menu_music() -> void:
	queue_menu_music()


func stop_boss_music() -> void:
	fade_out(boss_player, 2.0)
	queue_battle_music()


func fade_out(audio_player: AudioStreamPlayer, time_to_fade: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(audio_player, "volume_db", -60, time_to_fade).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func fade_in(audio_player: AudioStreamPlayer, time_to_fade: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(audio_player, "volume_db", 0, time_to_fade).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func _on_Boss_spawned(_boss: Boss, data: BossData) -> void:
	queue_boss_music(data.boss_music)


func _on_Boss_defeated(_boss: Boss) -> void:
	stop_boss_music()
