class_name LevelLoading
extends Node


const GAME_SCENE = preload("res://Game/Game.tscn")


static func load_level(scene_tree: SceneTree, level_scene: PackedScene) -> void:
	var current_scene: Node = scene_tree.current_scene
	scene_tree.root.remove_child(current_scene)
	current_scene.queue_free()
	
	var game: Game = GAME_SCENE.instantiate()
	game.level_scene = level_scene
	scene_tree.root.add_child(game)
	scene_tree.current_scene = game
