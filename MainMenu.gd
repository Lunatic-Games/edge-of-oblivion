extends Node

onready var start_page = $StartPage
onready var credits_page = $CreditsPage

func _on_PlayButton_pressed():
	get_tree().change_scene_to(load("res://GameScene.tscn"))


func _on_CreditsButton_pressed():
	start_page.visible = false
	credits_page.visible = true

func _on_ReturnToStartPage_pressed():
	credits_page.visible = false
	start_page.visible = true
