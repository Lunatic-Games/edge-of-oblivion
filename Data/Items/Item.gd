class_name Item
extends Control

signal update_triggered
signal setup_completed
signal tier_increased

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


func is_max_tier() -> bool:
	assert(current_tier <= data.max_tier, "Current tier higher than max tier")
	return current_tier == data.max_tier
