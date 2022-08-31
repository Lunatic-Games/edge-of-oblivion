extends Node2D

func _ready():
	GameManager.startGame()
	TurnManager.initialize()
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("playerDied", self, "gameOver")

func gameOver():
	get_tree().paused = true
	$Canvas/GameOver.visible = true


func _on_MenuButton_pressed():
	get_tree().quit()
