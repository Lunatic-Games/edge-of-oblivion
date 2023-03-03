extends Node



func _on_PlayButton_pressed():
	get_tree().change_scene_to(load("res://GameScene.tscn"))
