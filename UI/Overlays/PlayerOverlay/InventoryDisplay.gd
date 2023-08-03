class_name InventoryDisplay
extends HBoxContainer


const ADDED_DROP_DISTANCE: float = 50.0
const ADDED_DROP_TIME_SECONDS: float = 0.5
const TIER_UP_ROTATE_DEGREES: float = 10
const TIER_UP_ROTATE_TIME_SECONDS: float = 0.5


var items: Dictionary = {}  # ItemData : Item Scene

func _on_item_added_to_inventory(item: Item, item_data: ItemData, animate: bool = true) -> void:
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


func _on_item_upgraded(item: Item, item_data: ItemData, animate: bool = true) -> void:
	if animate == false:
		return
	
	var rotate_tween: Tween = create_tween()
	rotate_tween.tween_property(item, "rotation_degrees", TIER_UP_ROTATE_DEGREES,
		TIER_UP_ROTATE_TIME_SECONDS / 4.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	rotate_tween.tween_property(item, "rotation_degrees", -TIER_UP_ROTATE_DEGREES,
		TIER_UP_ROTATE_TIME_SECONDS / 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	rotate_tween.tween_property(item, "rotation_degrees", 0, 
		TIER_UP_ROTATE_TIME_SECONDS / 4.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
