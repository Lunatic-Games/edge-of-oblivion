class_name GoldDisplay
extends HBoxContainer


@onready var label: Label = $Label


func set_display_amount(amount: int) -> void:
	label.text = str(amount)
