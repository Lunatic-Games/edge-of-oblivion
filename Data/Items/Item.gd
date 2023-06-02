class_name Item
extends Control

signal update_triggered
signal setup_completed
signal tier_increased

var user: Unit
var current_tier = 0
var max_tier = 3

@onready var texture_rect: TextureRect = $Texture
@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	appear_unready(false)


func update():
	update_triggered.emit()
	GlobalLogicTreeSignals.item_update_triggered.emit(self)


func setup(data) -> void:
	texture_rect.texture = data.sprite
	
	setup_completed.emit()
	GlobalLogicTreeSignals.item_setup_completed.emit(self)


func set_sprite_color(color: Color):
	texture_rect.modulate = color


func appear_ready() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(texture_rect, "self_modulate:a", 1.0, 0.2)
	
	animator.play("ready")


func appear_unready(play_animation: bool = true) -> void:
	var tween: Tween = get_tree().create_tween().set_parallel()
	
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
	assert(current_tier <= max_tier, "Current tier higher than max tier")
	return current_tier == max_tier
