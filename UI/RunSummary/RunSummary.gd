class_name RunSummary
extends VBoxContainer


const UNLOCKED_ITEM_TEXTURE_SCENE: PackedScene = preload("res://Menus/VictoryMenu/UnlockedItemTexture.tscn")

@onready var xp_amount_label: Label = $XpGained/AmountLabel
@onready var xp_progress_bar: ProgressBar = $ProgressBar
@onready var level_up_label: Label = $LevelUpLabel
@onready var items_unlocked_label: Label = $ItemsUnlockedLabel
@onready var items_unlocked_container: BoxContainer = $ItemContainer


func update(xp_gained: int, did_level_up: bool):
	xp_amount_label.text = str(xp_gained)
	level_up_label.visible = did_level_up
	
	var items_unlocked: Array[ItemData] = []
	if did_level_up:
		items_unlocked.append_array(GlobalAccount.get_items_unlocked_for_current_level())
	items_unlocked_label.visible = !items_unlocked.is_empty()
	items_unlocked_container.visible = !items_unlocked.is_empty()
	
	var current_xp: int = GlobalAccount.xp
	var xp_till_next_level: int = GlobalAccount.get_xp_to_next_level()
	if xp_till_next_level <= 0:  # No next level
		xp_progress_bar.value = xp_progress_bar.max_value
	else:
		var ratio_to_next_level: float = float(current_xp) / float(xp_till_next_level)
		xp_progress_bar.value = ratio_to_next_level * xp_progress_bar.max_value
	
	for child in items_unlocked_container.get_children():
		child.hide()
		child.queue_free()
	
	for item_unlocked in items_unlocked:
		var item_texture: TextureRect = UNLOCKED_ITEM_TEXTURE_SCENE.instantiate()
		item_texture.texture = item_unlocked.sprite
		items_unlocked_container.add_child(item_texture)
