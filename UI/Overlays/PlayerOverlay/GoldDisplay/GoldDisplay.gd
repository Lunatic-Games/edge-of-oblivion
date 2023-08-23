class_name GoldDisplay
extends HBoxContainer


var current_displayed: int = 0
var target: int = 0

@onready var label: Label = $Label
@onready var tick_timer: Timer = $TickTimer


func set_display_amount(amount: int, animate: bool = true) -> void:
	target = amount
	if animate == true and current_displayed != target:
		tick_timer.start()
	
	if animate == false:
		current_displayed = target
		label.text = str(amount)


func _on_tick_timer_timeout() -> void:
	if current_displayed < target:
		current_displayed += 1
	elif current_displayed > target:
		current_displayed -= 1
	else:
		tick_timer.stop()
	
	label.text = str(current_displayed)
