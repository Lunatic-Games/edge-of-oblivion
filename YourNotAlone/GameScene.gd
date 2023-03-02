extends Node2D

func _ready():
	GameManager.startGame()
	TurnManager.initialize()
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("playerDied", self, "gameOver")

func gameOver():
	get_tree().paused = true
	$Canvas/GameOver.visible = true

func game_won():
	get_tree().paused = true
	$Canvas/Victory.visible = true

func _on_MenuButton_pressed():
	get_tree().change_scene_to(load("res://MainMenu.tscn"))
	GameManager.stop_game()
	get_tree().paused = false


func _on_Restart_pressed():
	GameManager.stop_game()
	get_tree().paused = false
	yield(get_tree(), "idle_frame")
	$Canvas/GameOver.visible = false
	get_tree().change_scene_to(load("res://GameScene.tscn"))


func _on_VictoryMainMenu_pressed():
	get_tree().change_scene_to(load("res://MainMenu.tscn"))
	GameManager.stop_game()
	get_tree().paused = false
