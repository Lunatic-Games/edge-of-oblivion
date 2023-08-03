class_name Entity
extends Node2D


signal update_triggered
signal died

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
		health.hit_zero.connect(_on_health_hit_zero)
	else:
		health_bar.hide()
	
	if data.occupancy_data != null:
		occupancy = EntityOccupancy.new(self, data.occupancy_data)


func update():
	update_triggered.emit()
	GlobalLogicTreeSignals.entity_update_triggered.emit(self)


func _on_health_hit_zero():
	occupancy.current_tile.occupant = null
	died.emit()
	
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "global_position:y", -25.0, 0.5).as_relative().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	queue_free()
