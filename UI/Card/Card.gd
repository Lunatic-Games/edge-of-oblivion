class_name Card
extends Control

signal selected
signal disappeared

const FLOAT_UP_DISTANCE: float = 200.0

var item_data: ItemData
var hover_tween: Tween = null

@onready var ray_animator: AnimationPlayer = $RayAnimator
@onready var ray_emitter: GPUParticles2D = $RayParticles

@onready var texture: TextureRect = $Texture
@onready var tier_up_banner: TextureRect = $Texture/TierUpBanner
@onready var card_name: Label = $Texture/MarginContainer/VBoxContainer/Name
@onready var item_sprite: TextureRect = $Texture/MarginContainer/VBoxContainer/ItemSprite
@onready var card_description: RichTextLabel = $Texture/MarginContainer/VBoxContainer/CardDescription

@onready var damage_icon_text: RichTextLabel = $Icons/DamageIcon/RichTextLabel
@onready var activation_icon_text: RichTextLabel = $Icons/ActivationIcon/RichTextLabel


func _ready() -> void:
	modulate.a = 0.0


func setup(card_item_data: ItemData, current_tier: int, animate: bool = true):
	card_name.text = card_item_data.item_name
	item_sprite.texture = card_item_data.sprite
	
	damage_icon_text.text = str(card_item_data.item_damage)
	activation_icon_text.text = str(card_item_data.max_turn_timer)
	
	match current_tier:
		1: 
			card_description.text = card_item_data.tier1Text
		2: 
			card_description.text = card_item_data.tier2Text
			tier_up_banner.show()
		3: 
			card_description.text = card_item_data.tier3Text
			tier_up_banner.show()
		
	item_data = card_item_data
	
	if animate:
		modulate.a = 0.0
		
		await get_tree().process_frame
		var tween: Tween = create_tween()
		tween.set_parallel(true)
		
		position.y += FLOAT_UP_DISTANCE
		tween.tween_property(self, "position:y", -FLOAT_UP_DISTANCE, 0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	hover_tween = create_tween()
	hover_tween.tween_property(texture, "position:y", -10, 2.0).as_relative()
	hover_tween.chain().tween_property(texture, "position:y", 10, 2.0).as_relative()
	hover_tween.set_loops()


func disappear(float_up: bool):
	var tween: Tween = create_tween().set_parallel(true)
	if float_up:
		tween.tween_property(self, "position:y", -50.0, 0.25).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.tween_property(self, "position:y", FLOAT_UP_DISTANCE, 0.25).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	disappeared.emit()


func _on_Button_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(texture, "scale", Vector2(1.1, 1.1), 0.2)
	z_index = 1 # Ensure the current card, and vfx appear over other cards
	ray_emitter.emitting = true
	ray_animator.play("rays_in")


func _on_Button_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(texture, "scale", Vector2(1.0, 1.0), 0.3)
	z_index = 0
	ray_emitter.emitting = false
	ray_animator.play("rays_out")
	hover_tween.play()


func _on_Button_button_down() -> void:
	hover_tween.pause()
	var tween: Tween = create_tween()
	tween.tween_property(texture, "scale", Vector2(0.95, 0.95), 0.2)


func _on_Button_button_up() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(texture, "scale", Vector2(1.0, 1.0), 0.2)
	var player: Player = get_tree().get_nodes_in_group("player")[0]
	player.gain_item(item_data)
	selected.emit()
