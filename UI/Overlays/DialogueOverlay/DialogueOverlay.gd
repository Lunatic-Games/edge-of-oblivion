class_name DialogueOverlay
extends CanvasLayer


signal next_triggered
signal option_selected(option_name: String)

const TEXT_ANIMATE_TIME_SECONDS: float = 0.1
const OPTION_SCENE: PackedScene = preload("res://UI/Overlays/DialogueOverlay/DialogueOption/DialogueOption.tscn")

var has_priority: bool = false
var text_animate_timer: float = 0.0

@onready var title_label: Label = $DialogueBox/TitleBox/Title
@onready var dialogue_label: Label = $DialogueBox/CenterContainer/VBoxContainer/Dialogue
@onready var option_container: VBoxContainer = $DialogueBox/CenterContainer/VBoxContainer/Options


func _input(event) -> void:
	if visible == false:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			interacted_with()
			#get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if visible == false:
		return
	
	text_animate_timer += delta
	
	while text_animate_timer > TEXT_ANIMATE_TIME_SECONDS:
		text_animate_timer -= delta
		if dialogue_label.visible_characters < dialogue_label.text.length():
			dialogue_label.visible_characters += 1


func display_text(text: String, title: String = "") -> void:
	title_label.text = title
	dialogue_label.text = text
	dialogue_label.visible_characters = 0
	option_container.hide()


func display_options(options: Array[String], prompt_text: String = "", title: String = "") -> void:
	assert(options.is_empty() == false, "No options provided.")
	
	title_label.text = title
	dialogue_label.text = prompt_text
	dialogue_label.visible_characters = 0
	for child in option_container.get_children():
		child.hide()
		child.queue_free()
	
	for option in options:
		var option_button: Button = OPTION_SCENE.instantiate()
		option_button.text = option
		option_container.add_child(option_button)
		option_button.pressed.connect(_on_option_button_pressed.bind(option))
	option_container.show()


func interacted_with():
	var n_visible_characters: int = dialogue_label.visible_characters
	if n_visible_characters < dialogue_label.text.length():
		dialogue_label.visible_characters = dialogue_label.text.length()
	else:
		next_triggered.emit()


func open():
	has_priority = true
	show()


func close():
	has_priority = false
	hide()


func _on_option_button_pressed(option_text: String) -> void:
	option_selected.emit(option_text)
