extends Node



func _on_PlayButton_pressed():
	print("Pressed")
	get_tree().change_scene_to(load("res://GameScene.tscn"))
