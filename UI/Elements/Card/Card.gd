class_name Card
extends Control

signal selected

var held_item_data: ItemData = null
var hover_tween: Tween = null
var is_locked: bool = false
var is_hovered: bool = false

@onready var ray_animator: AnimationPlayer = $RayAnimator
@onready var ray_emitter: GPUParticles2D = $RayParticles

@onready var background: TextureRect = $Background
@onready var tier_up_banner: TextureRect = $Background/TierUpBanner
@onready var card_name: Label = $Background/Name
@onready var item_sprite: TextureRect = $Background/ItemSprite
@onready var card_description: RichTextLabel = $Background/BottomText/Description
@onready var flavor_text: Label = $Background/BottomText/FlavorText
@onready var star_container: Container = $Background/StarContainer

@onready var locked_rect: ColorRect = $Background/LockedRect
@onready var locked_label: Label = $Background/LockedRect/LockedLabel
@onready var cost_label: Label = $Background/Cost


func setup(item_data: ItemData, item_tier: int, forge_level: int = 1, hover: bool = true):
	held_item_data = item_data
	
	card_name.text = item_data.item_name
	item_sprite.texture = item_data.sprite
	
	card_description.text = item_data.get_card_text(item_tier)
	if item_tier > 1:
		tier_up_banner.show()
	
	flavor_text.text = item_data.flavor_text
	
	update_stars(forge_level)
	
	if hover and hover_tween == null:
		hover_tween = create_tween()
		hover_tween.tween_property(background, "position:y", -10, 2.0).as_relative()
		hover_tween.chain().tween_property(background, "position:y", 10, 2.0).as_relative()
		hover_tween.set_loops()


func update_stars(forge_level: int = 1) -> void:
	for i in star_container.get_child_count():
		star_container.get_child(i).visible = forge_level > i + 1


func lock(text: String = "LOCKED") -> void:
	locked_label.text = text
	is_locked = true
	locked_rect.show()
	_on_Button_mouse_exited()


func un_lock() -> void:
	is_locked = false
	locked_rect.hide()


func show_cost(forge_level: int = 1) -> void:
	cost_label.text = str(held_item_data.get_cost(forge_level)) + "G"
	cost_label.show()


func hide_cost() -> void:
	cost_label.hide()


func _on_Button_mouse_entered() -> void:
	if is_locked:
		return
	
	var tween: Tween = create_tween()
	tween.tween_property(background, "scale", Vector2(1.1, 1.1), 0.2)
	z_index = 1 # Ensure the current card, and vfx appear over other cards
	ray_emitter.emitting = true
	ray_animator.play("rays_in")
	is_hovered = true


func _on_Button_mouse_exited() -> void:
	if is_hovered == false:
		return
	
	var tween: Tween = create_tween()
	tween.tween_property(background, "scale", Vector2(1.0, 1.0), 0.3)
	z_index = 0
	ray_emitter.emitting = false
	ray_animator.play("rays_out")
	if hover_tween != null:
		hover_tween.play()
	is_hovered = false


func _on_Button_button_down() -> void:
	if is_locked:
		return
	
	if hover_tween != null:
		hover_tween.pause()
	var tween: Tween = create_tween()
	tween.tween_property(background, "scale", Vector2(0.95, 0.95), 0.2)


func _on_Button_button_up() -> void:
	if is_locked:
		return
	
	var tween: Tween = create_tween()
	tween.tween_property(background, "scale", Vector2(1.0, 1.0), 0.2)
	selected.emit()
