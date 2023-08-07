class_name LevelLoading
extends Node


const GAME_SCENE = preload("res://Game/Game.tscn")


static func load_level(scene_tree: SceneTree, level_data: LevelData) -> void:
	var current_scene: Node = scene_tree.current_scene
	scene_tree.root.remove_child(current_scene)
	current_scene.queue_free()
	
	await scene_tree.process_frame
	
	var game: Game = GAME_SCENE.instantiate()
	game.level_data = level_data
	scene_tree.root.add_child(game)
	scene_tree.current_scene = game
