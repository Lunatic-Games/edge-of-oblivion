class_name Card
extends Control

signal selected

var item_data: ItemData

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var ray_animator: AnimationPlayer = $RayAnimator
@onready var ray_emitter: GPUParticles2D = $RayParticles
@onready var background: Control = $Background
@onready var  card_name: RichTextLabel = $CardTop/Name
@onready var card_sprite: TextureRect = $CardTop/TextureRect
@onready var damage_icon_text: RichTextLabel = $CardTop/BaseIcons/DamageIcon/RichTextLabel
@onready var activation_icon_text: RichTextLabel = $CardTop/BaseIcons/ActivationIcon/RichTextLabel
@onready var card_description: RichTextLabel = $CardBottom/CardDescription

func setup(card_item_data: ItemData, current_tier: int, animate: bool = true):
	card_sprite.texture = card_item_data.sprite
	card_name.text = "[center]" + card_item_data.item_name
	damage_icon_text.text = str(card_item_data.item_damage)
	activation_icon_text.text = str(card_item_data.max_turn_timer)
	match current_tier:
		1: 
			card_description.text = "[center]" + card_item_data.tier1Text
		2: 
			card_description.text = "[center]" + card_item_data.tier2Text
		3: 
			card_description.text = "[center]" + card_item_data.tier3Text
		
	item_data = card_item_data
	if animate:
		animator.play("spawn")
		await get_tree().process_frame
		
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "position:y", -100.0, 0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	else:
		animator.play("setup")


func _on_Background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		var player: Player = get_tree().get_nodes_in_group("player")[0]
		player.gain_item(item_data)
		selected.emit()


func _on_Background_mouse_entered() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
	z_index = 1
	ray_emitter.emitting = true
	ray_animator.play("rays_in")


func _on_Background_mouse_exited() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
	z_index = 0
	ray_emitter.emitting = false
	ray_animator.play("rays_out")
