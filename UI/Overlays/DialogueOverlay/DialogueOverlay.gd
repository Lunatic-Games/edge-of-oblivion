class_name DialogueOverlay
extends CanvasLayer


const TEXT_ANIMATE_TIME_SECONDS: float = 0.1

var has_priority: bool = false
var pages: Array[String] = []
var page_index: int = 0
var text_animate_timer: float = 0.0

@onready var title_label: Label = $DialogueBox/TitleBox/Title
@onready var dialogue_label: Label = $DialogueBox/CenterContainer/Dialogue


func _input(event) -> void:
	if visible == false:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			interacted_with()
			get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if visible == false:
		return
	
	text_animate_timer += delta
	
	while text_animate_timer > TEXT_ANIMATE_TIME_SECONDS:
		text_animate_timer -= delta
		if dialogue_label.visible_characters < dialogue_label.text.length():
			dialogue_label.visible_characters += 1


func begin_dialogue(title: String, new_dialogue: Array[String]) -> void:
	if new_dialogue.size() == 0:
		return
	
	title_label.text = title
	pages = new_dialogue
	page_index = 0
	dialogue_label.text = pages[page_index]
	dialogue_label.visible_characters = 0
	has_priority = true
	show()


func interacted_with():
	var n_visible_characters: int = dialogue_label.visible_characters
	if n_visible_characters < dialogue_label.text.length():
		skip_to_end()
	else:
		next_page()


func next_page() -> void:
	if page_index == pages.size() -1:
		close()
		return
	
	page_index += 1
	dialogue_label.text = pages[page_index]
	dialogue_label.visible_characters = 0


func close():
	has_priority = false
	hide()


func skip_to_end() -> void:
	dialogue_label.visible_characters = dialogue_label.text.length()
