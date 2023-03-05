extends Control

signal selectionMade

var itemData

onready var tween = $Tween
onready var animator = $AnimationPlayer

func setup(resource, currentTier, animate):
	$Sprite.texture = resource.sprite
	match currentTier:
		1: 
			$UpgradeText.bbcode_text = resource.tier1Text
		2: 
			$UpgradeText.bbcode_text = resource.tier2Text
		3: 
			$UpgradeText.bbcode_text = resource.tier3Text
		
	itemData = resource
	if animate:
		animator.play("spawn")
		yield(get_tree(), "idle_frame")
		tween.interpolate_property(self, "rect_position", rect_position + Vector2(0, -100), rect_position, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		animator.play("setup")

func _on_Background_gui_input(event):
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.gainItem(itemData)
		emit_signal("selectionMade")
