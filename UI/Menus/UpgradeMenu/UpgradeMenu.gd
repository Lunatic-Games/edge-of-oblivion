@tool
class_name UpgradeMenu
extends CanvasLayer


#const PLAYER_DATA: PlayerData = preload("res://Data/Entities/Player/PlayerData.tres")

@export_range(1, 5, 1, "or_greater") var max_n_cards_to_spawn: int = 3:
	set = _set_n_card_to_spawn

var inventory_limit: int = 5
var n_queued_upgrades: int = 0  # For if multiple level ups occur
var has_priority: bool = false  # Player won't move when upgrade menu has priority

# Size of (inventory_limit + 1) and contains ints between 0 and max_n_cards_to_spawn
var n_new_items_for_each_inventory_size = []


@onready var background_animator: AnimationPlayer = $Background/BackgroundAnimator
@onready var title: Label = $Title
@onready var title_animator: AnimationPlayer = $Title/TitleAnimator
@onready var card_display: CardDisplay = $CardDisplay
@onready var visibility_button: Button = $VisibilityButton


func _ready() -> void:
	#inventory_limit = PLAYER_DATA.inventory_data.max_inventory_size
	inventory_limit = 5
	_resize_n_new_items_for_each_inventory_size()
	notify_property_list_changed()


# Upgrades are queued during turn and then done on start of player turn
func queue_upgrade() -> void:
	n_queued_upgrades += 1


func display() -> void:
	assert(n_queued_upgrades > 0, "Trying to display upgrade menu without queued upgrade!")
	
	has_priority = true
	
	if card_display.get_child_count() > 0:
		return
	
	n_queued_upgrades -= 1
	
	var possible_items: Array[ItemData] = []
	possible_items.append_array(GlobalAccount.unlocked_items)
	possible_items.shuffle()
	
	var player: Player = GlobalGameState.get_player()
	var player_inventory: Inventory = player.inventory
	var inventory_size: int = min(player_inventory.items.size(), inventory_limit)
	var preferred_n_new_items: int = n_new_items_for_each_inventory_size[inventory_size]
	
	var new_items: Array[ItemData] = []
	var upgrades: Array[ItemData] = []
	for item_data in possible_items:
		var item: Item = player_inventory.items.get(item_data, null)
		if item == null and new_items.size() < max_n_cards_to_spawn:
			new_items.append(item_data)
		elif item != null and upgrades.size() < max_n_cards_to_spawn and not item.is_max_tier():
			upgrades.append(item_data)
	
	var items_to_display: Array[ItemData] = []
	
	var n_new_items: int = 0
	if inventory_size < inventory_limit:
		# If there aren't enough upgrades to fill then try filling with more new items
		n_new_items = max(preferred_n_new_items, max_n_cards_to_spawn - upgrades.size())
		# Make sure it never exceeds max cards to spawn
		n_new_items = min(n_new_items, max_n_cards_to_spawn)
		# And lastly make sure the final n doesn't exceed the number available
		n_new_items = min(n_new_items, new_items.size())
		items_to_display.append_array(new_items.slice(0, n_new_items))
	
	var n_upgrades: int = max_n_cards_to_spawn - n_new_items
	items_to_display.append_array(upgrades.slice(0, n_upgrades))
	
	if items_to_display:
		card_display.display_items(items_to_display)
		if visible == false:  # Don't fade if multiple level ups being processed
			background_animator.play("fade_in")
		title_animator.play("pop_up")
		visibility_button.show()
		show()
	else:
		has_priority = false


func _on_card_display_card_selected() -> void:
	title_animator.play("fade_out")
	if n_queued_upgrades > 0:
		await card_display.finished_animating_selection
		display()
	else:
		has_priority = false
		background_animator.play("fade_out")
		visibility_button.hide()


func _set_n_card_to_spawn(value: int):
	max_n_cards_to_spawn = value
	notify_property_list_changed()


func _get_property_list() -> Array:
	var properties: Array[Dictionary] = []
	properties.append({
		"name": "# of new items for inventory size",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_GROUP
	})
	
	for i in inventory_limit + 1:
		var min_value: int = 0
		var max_value: int = max_n_cards_to_spawn
		if i == 0:
			min_value = max_n_cards_to_spawn
		elif i == inventory_limit:
			max_value = 0
		
		properties.append({
			"name": str(i),
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": str(min_value) + "," + str(max_value) + ",-1"  # -1 is trick to get slider
		})
	return properties


func _get(property: StringName) -> Variant:
	if not property.is_valid_int():
		return null
	
	var i: int = property.to_int()
	return n_new_items_for_each_inventory_size[i]


func _set(property: StringName, value: Variant) -> bool:
	if not property.is_valid_int():
		return false
	
	# This is needed if _set_inventory_limit hasn't been called yet
	_resize_n_new_items_for_each_inventory_size()
	
	var i: int = property.to_int()
	n_new_items_for_each_inventory_size[i] = value
	
	return true


func _resize_n_new_items_for_each_inventory_size():
	n_new_items_for_each_inventory_size.resize(inventory_limit + 1)
	for i in n_new_items_for_each_inventory_size.size():
		if i == 0:
			n_new_items_for_each_inventory_size[i] = max_n_cards_to_spawn
		elif i == n_new_items_for_each_inventory_size.size() - 1:
			n_new_items_for_each_inventory_size[i] = 0
		elif n_new_items_for_each_inventory_size[i] == null:
			n_new_items_for_each_inventory_size[i] = 0


func _on_visibility_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		title.hide()
		card_display.hide()
	else:
		title.show()
		card_display.show()
