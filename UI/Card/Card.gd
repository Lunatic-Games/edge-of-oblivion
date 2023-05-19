class_name Card
extends Control

signal selected

var held_item_data: ItemData = null
var hover_tween: Tween = null

@onready var ray_animator: AnimationPlayer = $RayAnimator
@onready var ray_emitter: GPUParticles2D = $RayParticles

@onready var background: TextureRect = $Background
@onready var tier_up_banner: TextureRect = $Background/TierUpBanner
@onready var card_name: Label = $Background/Name
@onready var item_sprite: TextureRect = $Background/ItemSprite
@onready var card_description: RichTextLabel = $Background/BottomText/Description
@onready var flavor_text: Label = $Background/BottomText/FlavorText

@onready var damage_icon_text: RichTextLabel = $Icons/DamageIcon/RichTextLabel
@onready var activation_icon_text: RichTextLabel = $Icons/ActivationIcon/RichTextLabel


func setup(item_data: ItemData, item_tier: int, hover: bool = true):
	held_item_data = item_data
	
	card_name.text = item_data.item_name
	item_sprite.texture = item_data.sprite
	
	damage_icon_text.text = str(item_data.item_damage)
	activation_icon_text.text = str(item_data.max_turn_timer)
	
	match item_tier:
		1: 
			card_description.text = item_data.tier1Text
		2: 
			card_description.text = item_data.tier2Text
			tier_up_banner.show()
		3: 
			card_description.text = item_data.tier3Text
			tier_up_banner.show()
	
	flavor_text.text = item_data.flavor_text
	
	if hover and hover_tween == null:
		hover_tween = create_tween()
		hover_tween.tween_property(background, "position:y", -10, 2.0).as_relative()
		hover_tween.chain().tween_property(background, "position:y", 10, 2.0).as_relative()
		hover_tween.set_loops()


func _on_Button_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(background, "scale", Vector2(1.1, 1.1), 0.2)
	z_index = 1 # Ensure the current card, and vfx appear over other cards
	ray_emitter.emitting = true
	ray_animator.play("rays_in")


func _on_Button_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(background, "scale", Vector2(1.0, 1.0), 0.3)
	z_index = 0
	ray_emitter.emitting = false
	ray_animator.play("rays_out")
	if hover_tween != null:
		hover_tween.play()


func _on_Button_button_down() -> void:
	if hover_tween != null:
		hover_tween.pause()
	var tween: Tween = create_tween()
	tween.tween_property(background, "scale", Vector2(0.95, 0.95), 0.2)


func _on_Button_button_up() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(background, "scale", Vector2(1.0, 1.0), 0.2)
	selected.emit()
