@icon("res://Assets/art/dialogue-state/question-mark.png")
class_name DS_Question
extends DialogueState


@export_multiline var prompt_text: String = ""
@export var options: Array[DialogueOptionData] = []
@export var use_entity_name_for_title: bool = true



func _ready() -> void:
	assert(options.is_empty() == false, "Options not specified for '" + name + "'")


func on_enter():
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	if dialogue_overlay == null:
		return
	
	dialogue_overlay.option_selected.connect(_on_option_selected)
	var title: String = ""
	
	if use_entity_name_for_title:
		var entity: Entity = owner as Entity
		var data: EntityData = entity.data
		title = data.entity_name
	
	var option_titles: Array[String] = []
	for option in options:
		option_titles.append(option.text)
	
	dialogue_overlay.display_options(option_titles, prompt_text, title)


func _on_option_selected(option_title: String):
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	dialogue_overlay.option_selected.disconnect(_on_option_selected)
	
	for option in options:
		if option.text == option_title:
			transition(get_node(option.state_on_chosen))
			return
	
	assert(false, "Failed to find option with matching name '" + option_title + "'")
