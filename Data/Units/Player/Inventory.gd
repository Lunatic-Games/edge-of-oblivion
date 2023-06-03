class_name Inventory
extends HBoxContainer


const ADDED_DROP_DISTANCE: float = 50.0
const ADDED_DROP_TIME_SECONDS: float = 0.5
const TIER_UP_SCALE_INCREASE: Vector2 = Vector2(0.4, 0.4)
const TIER_UP_SCALE_STAY_TIME_SECONDS: float = 0.3
const TIER_UP_SCALE_TIME_SECONDS: float = 0.5

var items: Dictionary = {}  # ItemData : Item Scene


func gain_item(item_data: ItemData, animate: bool = true) -> void:
	if item_data in items:
		_handle_upgrading_item(item_data, animate)
	else:
		_handle_new_item(item_data, animate)


func _handle_new_item(item_data: ItemData, animate: bool = true) -> void:
	var item: Item = item_data.item_scene.instantiate()
	item.current_tier = 1
	item.user = GameManager.player
	items[item_data] = item
	
	add_child(item)
	item.setup(item_data)
	
	if animate == false:
		return
	
	item.modulate.a = 0  # Hide until animation
	await get_tree().process_frame
	
	item.position.y -= ADDED_DROP_DISTANCE  # Bring up so can drop down to same position
	var tween = create_tween().set_parallel(true)
	tween.tween_property(item, "position:y", ADDED_DROP_DISTANCE, ADDED_DROP_TIME_SECONDS) \
		.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(item, "modulate:a", 1.0, ADDED_DROP_TIME_SECONDS) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func _handle_upgrading_item(item_data: ItemData, animate: bool = true) -> void:
	var item: Item = items[item_data]
	assert(item, "Trying to upgrade an item that the player doesn't have.")
	item.upgrade_tier()
	
	if item.is_max_tier():
		GlobalSignals.item_reached_max_tier.emit(item, item_data)
	
	if animate == false:
		return
	
	var up_tween: Tween = create_tween()
	up_tween.tween_property(item, "scale", TIER_UP_SCALE_INCREASE, TIER_UP_SCALE_TIME_SECONDS / 2.0) \
		.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(TIER_UP_SCALE_STAY_TIME_SECONDS).timeout
	
	var down_tween: Tween = create_tween()
	down_tween.tween_property(item, "scale", -TIER_UP_SCALE_INCREASE, TIER_UP_SCALE_TIME_SECONDS / 2.0) \
	.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
