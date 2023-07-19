class_name Level
extends Node2D


@export var data: LevelData = null

@onready var board: Board = $Board


func setup(level_data: LevelData) -> void:
	data = level_data
