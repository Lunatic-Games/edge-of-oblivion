class_name Item
extends Control

signal update_triggered
signal setup_completed
signal tier_increased

@export var primary_every_x_node: LT_EveryXCalls

var data: ItemData = null
var user: Unit = null
var current_tier: int = 0

@onready var texture_rect: TextureRect = $Texture
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var countdown_label: Label = $CountdownLabel


func setup(item_data: ItemData) -> void:
	data = item_data
	texture_rect.texture = data.sprite
	
	setup_completed.emit()
	GlobalLogicTreeSignals.item_setup_completed.emit(self)
	if primary_every_x_node != null:
		update_countdown()
		primary_every_x_node.evaluated.connect(_on_primary_every_x_node_evaluated)


func update():
	update_triggered.emit()
	GlobalLogicTreeSignals.item_update_triggered.emit(self)


func set_sprite_color(color: Color):
	texture_rect.modulate = color


func appear_ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(texture_rect, "self_modulate:a", 1.0, 0.2)
	
	animator.play("ready")


func appear_unready(play_animation: bool = true) -> void:
	var tween: Tween = create_tween().set_parallel()
	
	tween.tween_property(texture_rect, "self_modulate:a", 0.4, 0.2)
	if play_animation:
		animator.play("unready")


func upgrade_tier():
	if is_max_tier():
		return
	
	current_tier += 1
	tier_increased.emit()
	GlobalLogicTreeSignals.item_tier_increased.emit(self)
	update_countdown()  # Refresh in-case cooldown changed with tier-up


func is_max_tier() -> bool:
	assert(current_tier <= data.max_tier, "Current tier higher than max tier")
	return current_tier == data.max_tier


func update_countdown(animate: bool = true) -> void:
	if primary_every_x_node == null or countdown_label.visible == false:
		return
	
	primary_every_x_node.refresh()
	
	var times_evaluated: int = primary_every_x_node.times_evaluated
	var out_of: int = primary_every_x_node.x
	var countdown: int = out_of - times_evaluated
	countdown_label.text = str(countdown)
	
	if animate == false:
		return
	
	if primary_every_x_node.times_evaluated == 0:
		appear_unready()
	if primary_every_x_node.is_one_before():
		appear_ready()


func _on_primary_every_x_node_evaluated():
	update_countdown()
