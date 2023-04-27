class_name Item
extends Control


const VOLATILE_COLOR: Color = Color( 1, 0.556863, 0.34902, 1 )

var user: Unit
var current_tier = 0
var max_tier = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	user = get_tree().get_nodes_in_group("player")[0]
	appear_unready()


func update():
	GlobalLogicTreeSignals.item_update_triggered.emit(self)


func setup(data) -> void:
	sprite.texture = data.sprite
	
	GlobalLogicTreeSignals.item_setup_completed.emit(self)


func appear_ready(subtle: bool = false) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(sprite, "self_modulate:a", 1.0, 0.2)
	
	if subtle:
		return
	animator.play("ready")


func appear_unready(appear_volatile: bool = false) -> void:
	var tween: Tween = get_tree().create_tween().set_parallel()
	
	tween.tween_property(sprite, "self_modulate:a", 0.4, 0.2)
	animator.stop(true)
	
	tween.tween_property(sprite, "position:y", 32.0, 0.2)
	if appear_volatile:
		sprite.modulate = VOLATILE_COLOR


func upgrade_tier():
	if is_max_tier() == false:
		current_tier += 1
		GlobalLogicTreeSignals.item_tier_increased.emit(self)


func is_max_tier() -> bool:
	assert(current_tier <= max_tier, "Current tier higher than max tier")
	return current_tier == max_tier
