extends Control

signal selectionMade

var itemData

func setup(resource, currentTier):
	$Sprite.texture = resource.sprite
	match currentTier:
		1: 
			$UpgradeText.bbcode_text = resource.tier1Text
		2: 
			$UpgradeText.bbcode_text = resource.tier2Text
		3: 
			$UpgradeText.bbcode_text = resource.tier3Text
		
	itemData = resource
	

func _on_Background_gui_input(event):
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		var player = get_tree().get_nodes_in_group("player")[0]
		player.gainItem(itemData)
		emit_signal("selectionMade")
