extends Control


signal item_reached_max_tier(item_data: ItemData)

const ADDED_DROP_DISTANCE: float = 50.0
const ADDED_DROP_TIME_SECONDS: float = 0.5
const TIER_UP_SCALE_INCREASE: Vector2 = Vector2(0.4, 0.4)
const TIER_UP_SCALE_STAY_TIME_SECONDS: float = 0.3
const TIER_UP_SCALE_TIME_SECONDS: float = 0.5

var managed_items: Dictionary = {
	
}


func _ready() -> void:
	TurnManager.connect("player_turn_ended",Callable(self,"handle_items_triggering"))


func reset() -> void:
	managed_items = {}


func handle_items_triggering() -> void:
	for item in managed_items:
		managed_items[item].update()
	
	TurnManager.item_phase_ended()


func add_item(item_data: ItemData, animate: bool = true) -> void:
	var item: Item = item_data.item_scene.instantiate()
	item.current_tier = 1
	GameManager.player.item_container.add_child(item)
	managed_items[item_data] = item
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


func upgrade_item(item_data: ItemData) -> void:
	var item: Item = managed_items[item_data]
	var is_max_tier = item.upgrade_tier()
	
	if is_max_tier:
		FreeUpgradeMenu.remove_item_from_availability(item_data)
		item_reached_max_tier.emit(item_data)

	
	var up_tween = create_tween()
	up_tween.tween_property(item, "scale", TIER_UP_SCALE_INCREASE, TIER_UP_SCALE_TIME_SECONDS / 2.0) \
		.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(TIER_UP_SCALE_STAY_TIME_SECONDS).timeout
	
	var down_tween = create_tween()
	down_tween.tween_property(item, "scale", -TIER_UP_SCALE_INCREASE, TIER_UP_SCALE_TIME_SECONDS / 2.0) \
	.as_relative().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
