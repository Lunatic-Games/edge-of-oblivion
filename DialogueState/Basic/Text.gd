@icon("res://Assets/art/dialogue-state/speech.png")
class_name DS_Text
extends DialogueState


@export_multiline var text: Array[String] = []
@export var next_state: DialogueState = null
@export var use_entity_name_for_title: bool = true

var text_index: int = 0


func _ready() -> void:
	assert(text.is_empty() == false, "Text is not specified for '" + name + "'")
	assert(next_state != null, "Next state is not specified for '" + name + "'")


func on_enter():
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	if dialogue_overlay == null:
		return
	
	dialogue_overlay.next_triggered.connect(_on_next_triggered)
	text_index = 0
	display_text()


func display_text():
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	var title: String = ""
	
	if use_entity_name_for_title:
		var entity: Entity = owner as Entity
		var data: EntityData = entity.data
		title = data.entity_name
	
	dialogue_overlay.display_text(text[text_index], title)


func _on_next_triggered():
	text_index += 1
	var dialogue_overlay: DialogueOverlay = GlobalGameState.get_dialogue_overlay()
	
	if text_index >= text.size():
		dialogue_overlay.next_triggered.disconnect(_on_next_triggered)
		transition(next_state)
	else:
		display_text()
