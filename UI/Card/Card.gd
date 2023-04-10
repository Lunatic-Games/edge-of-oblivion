extends Control

signal selectionMade

var item_data

@onready var animator = $AnimationPlayer
@onready var star_emitter = $WaterfallStarParticle
@onready var background = $Background


func setup(resource, currentTier, animate):
	$Sprite2D.texture = resource.sprite
	$Name.text = "[center]" + resource.item_name
	match currentTier:
		1: 
			$UpgradeText.text = resource.tier1Text
		2: 
			$UpgradeText.text = resource.tier2Text
		3: 
			$UpgradeText.text = resource.tier3Text
		
	item_data = resource
	if animate:
		animator.play("spawn")
		await get_tree().process_frame
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:y", -100.0, 0.5).as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	else:
		animator.play("setup")


func _on_Background_gui_input(event):
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.gain_item(item_data)
		emit_signal("selectionMade")


func _on_Background_mouse_entered():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
	star_emitter.emitting = true


func _on_Background_mouse_exited():
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.3)
	star_emitter.emitting = false
