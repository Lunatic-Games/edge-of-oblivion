class_name Card
extends Control

signal selected

var item_data: ItemData

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var star_emitter: GPUParticles2D = $WaterfallStarParticle
@onready var background: Control = $Background


func setup(card_item_data: ItemData, current_tier: int, animate: bool = true):
	$Sprite2D.texture = card_item_data.sprite
	$Name.text = "[center]" + card_item_data.item_name
	match current_tier:
		1: 
			$UpgradeText.text = card_item_data.tier1Text
		2: 
			$UpgradeText.text = card_item_data.tier2Text
		3: 
			$UpgradeText.text = card_item_data.tier3Text
		
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
	star_emitter.emitting = true


func _on_Background_mouse_exited() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
	star_emitter.emitting = false
