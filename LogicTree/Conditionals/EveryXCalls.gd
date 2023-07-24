@icon("res://Assets/art/logic-tree/conditionals/if-n.png")
class_name LT_EveryXCalls
extends LogicTreeConditional


@export_range(1, 100, 1, "or_greater") var x: int = 1
@export var x_override: LT_IntVariable
@export var on_one_before: bool = false

@export_group("Item configuration")
@export var auto_update_item_ready_state: bool = false
@export var auto_update_item_countdown: bool = false

var times_evaluated: int = 0
var met_condition: bool = false


func _ready() -> void:
	if x_override != null:
		x_override.changed.connect(refresh)
	
	var owner_item: Item = owner as Item
	if owner_item == null:
		return
	
	owner_item.setup_completed.connect(_on_owner_item_setup_completed)


func refresh() -> void:
	if x_override != null:
		x = x_override.value
	
	var owner_item: Item = owner as Item
	if owner_item == null:
		return
	
	if auto_update_item_ready_state:
		update_item_state(owner_item)
	
	if auto_update_item_countdown:
		update_item_countdown(owner_item)


func is_one_before() -> bool:
	return times_evaluated == x - 1


func perform_behavior() -> void:
	times_evaluated += 1
	if on_one_before and times_evaluated == x - 1:
		met_condition = true
	elif on_one_before == false and times_evaluated >= x:
		met_condition = true
	else:
		met_condition = false
	
	while times_evaluated >= x:
		times_evaluated -= x
	
	refresh()


func evaluate_condition() -> bool:
	return met_condition


func update_item_state(item: Item):
	if times_evaluated == 0:
		item.appear_unready()
	elif is_one_before():
		item.appear_ready()


func update_item_countdown(item: Item):
	var countdown: int = x - times_evaluated
	item.countdown_label.text = str(countdown)


func _on_owner_item_setup_completed():
	refresh()
