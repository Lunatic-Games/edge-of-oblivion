class_name Entity
extends Node2D


signal update_triggered

var data: EntityData = null
var health: EntityHealth = null
var occupancy: EntityOccupancy = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar


func setup(p_data: EntityData) -> void:
	assert(p_data != null, "Null entity data")
	
	data = p_data
	
	if data.health_data != null:
		health = EntityHealth.new(self, data.health_data)
	else:
		health_bar.hide()
	
	if data.occupancy_data != null:
		occupancy = EntityOccupancy.new(self, data.occupancy_data)


func update():
	update_triggered.emit()
	GlobalLogicTreeSignals.entity_update_triggered.emit(self)

