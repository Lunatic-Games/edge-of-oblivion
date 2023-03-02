extends Node2D

enum MUSIC_STATE {
	menu,
	battle,
	boss
}

var menu_music = [preload("res://Assets/audio/music/Menu/Fall-From-Grace.mp3"), preload("res://Assets/audio/music/Menu/Lurking-Evil.mp3")]
var battle_music = [
	preload("res://Assets/audio/music/Battle/chase.mp3"),
	preload("res://Assets/audio/music/Battle/Dragon-Castle.mp3"),
	preload("res://Assets/audio/music/Battle/Dragon-World.mp3"),
	preload("res://Assets/audio/music/Battle/Durandal.mp3"),
	preload("res://Assets/audio/music/Battle/Hitman.mp3"),
	preload("res://Assets/audio/music/Battle/Hostiles-Inbound.mp3"),
	preload("res://Assets/audio/music/Battle/The-Torch-Of-Knowledge.mp3")
]
var current_music_state = MUSIC_STATE.menu

onready var battle_player = $BattleMusicPlayer
onready var menu_player = $MenuMusicPlayer
onready var boss_player = $BossMusicPlayer
onready var tween = $Tween

func _ready():
	battle_player.connect("finished", self, "queue_battle_music")
	GameManager.connect("game_start", self, "start_game_audio")
	GameManager.connect("menu_loaded", self, "start_menu_music")
	GameManager.connect("boss_spawned", self, "start_boss_music")
	GameManager.connect("boss_defeated", self, "stop_boss_music")
	start_menu_music()

func queue_battle_music():
	fade_out(menu_player, 2.0)
	battle_player.stream = battle_music[randi()%battle_music.size()]
	fade_in(battle_player, 1.1)
	battle_player.play()

func queue_menu_music():
	fade_out(battle_player, 1.0)
	fade_out(boss_player, 1.0)
	menu_player.stream = menu_music[randi()%menu_music.size()]
	fade_in(menu_player, 2.0)
	menu_player.play()

func queue_boss_music(boss_music):
	fade_out(battle_player, 2.0)
	boss_player.stream = boss_music
	fade_in(boss_player, 1.0)
	boss_player.play()

func start_game_audio():
	stop_boss_music()

func start_menu_music():
	queue_menu_music()

func start_boss_music(boss_music):
	queue_boss_music(boss_music)

func stop_boss_music():
	fade_out(boss_player, 2.0)
	queue_battle_music()

func fade_out(audio_player, time_to_fade):
	tween.interpolate_property(audio_player, "volume_db", audio_player.volume_db, -30, time_to_fade, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func fade_in(audio_player, time_to_fade):
	tween.interpolate_property(audio_player, "volume_db", audio_player.volume_db, 0, time_to_fade, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
