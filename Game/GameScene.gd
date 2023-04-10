extends Node2D


func _ready():
	GameManager.start_game()
	TurnManager.initialize()
	
	var player = get_tree().get_nodes_in_group("player")[0]
	player.died.connect(game_over)


func game_over():
	await get_tree().create_timer(1.0).timeout
	FreeUpgradeMenu.disableDisplay()
	get_tree().paused = true
	$Canvas/GameOver.visible = true


func game_won():
	get_tree().paused = true
	$Canvas/Victory.visible = true


func _on_MenuButton_pressed():
	GameManager.change_to_main_menu()
	GameManager.stop_game()
	get_tree().paused = false


func _on_Restart_pressed():
	GameManager.stop_game()
	get_tree().paused = false
	await get_tree().process_frame
	$Canvas/GameOver.visible = false
	get_tree().change_scene_to_file("res://Game/GameScene.tscn")


func _on_VictoryMainMenu_pressed():
	GameManager.change_to_main_menu()
	GameManager.stop_game()
	get_tree().paused = false
