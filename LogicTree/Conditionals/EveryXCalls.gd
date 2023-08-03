@icon("res://Assets/art/logic-tree/conditionals/if-n.png")
class_name LT_EveryXCalls
extends LogicTreeConditional


@export_range(1, 100, 1, "or_greater") var x: int = 1
@export var x_override: LT_IntVariable
@export var on_one_before: bool = false

@export_group("Item configuration")
@export var auto_update_item_ready_state: bool = false
@export var auto_update_item_countdown: bool = false

@export_group("Enemy configuration")
@export var auto_update_enemy_ready_state: bool = false
@export var auto_update_enemy_attack_bar: bool = false

var times_evaluated: int = 0
var met_condition: bool = false


func _ready() -> void:
	if x_override != null:
		x_override.changed.connect(refresh)
	
	var owner_item: Item = owner as Item
	if owner_item != null:
		owner_item.ready.connect(_on_owner_item_ready)
	
	var owner_enemy: Enemy = owner as Enemy
	if owner_enemy != null:
		owner_enemy.ready.connect(_on_owner_enemy_ready)


func refresh() -> void:
	if x_override != null:
		x = x_override.value
	
	var owner_item: Item = owner as Item
	if owner_item != null:
		if auto_update_item_ready_state:
			update_item_ready_state(owner_item)
		if auto_update_item_countdown:
			update_item_countdown(owner_item)
	
	var owner_enemy: Enemy = owner as Enemy
	if owner_enemy != null:
		if auto_update_enemy_ready_state:
			update_enemy_ready_state(owner_enemy)
		if auto_update_enemy_attack_bar:
			update_enemy_attack_bar(owner_enemy)


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


func update_item_ready_state(item: Item):
	if is_one_before():
		item.appear_ready()
	elif times_evaluated == 0:
		item.appear_unready()


func update_item_countdown(item: Item):
	var countdown: int = x - times_evaluated
	item.countdown_label.text = str(countdown)


func update_enemy_ready_state(enemy: Enemy):
	if is_one_before():
		enemy.appear_ready()
	elif times_evaluated == 0:
		enemy.appear_unready()


func update_enemy_attack_bar(enemy: Enemy):
	enemy.attack_bar.set_progress(float(times_evaluated) / float(x - 1))


func _on_owner_item_ready():
	refresh()


func _on_owner_enemy_ready():
	refresh()
