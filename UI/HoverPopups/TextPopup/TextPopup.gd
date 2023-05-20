extends Button

@export var display_string: String = "Lorem ipsum dolor iset imun babab baba chug wug!"

var delay: float = 0.75
var time_hovered: float = 0.0
var hovered: bool = false
var spawned_popup: bool = false

@onready var translation_container: Node2D = $TranslationContainer
@onready var panel: PanelContainer = $TranslationContainer/BackgroundPanel
@onready var popup_text: RichTextLabel = $TranslationContainer/BackgroundPanel/PanelContainer/InfoText

func _ready():
	popup_text.text = display_string

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	remove_text_popup()
	time_hovered = 0
	hovered = false

func _process(delta):
	if hovered && !spawned_popup:
		time_hovered += delta
		if time_hovered >= delay:
			spawn_text_popup()

func spawn_text_popup():
	spawned_popup = true
	translation_container.global_position = get_global_mouse_position() + Vector2(-10, -10)
	translation_container.global_position -= panel.size
	
	"""
	print("Screen position: ", get_screen_position())
	print("Spawn point: ", translation_container.global_position)
	print("Global Mouse POS: ", get_global_mouse_position())
	
	var left_border = get_screen_position().x - get_viewport_rect().size.x
	var top_border = get_screen_position().y - get_viewport_rect().size.y/2
	if translation_container.global_position.x < left_border:
		translation_container.global_position.x = left_border
	if translation_container.global_position.y < top_border:
		translation_container.global_position.y = top_border
	
	translation_container.global_position.x = left_border
	"""

	
	translation_container.visible = true
	
	

func remove_text_popup():
	spawned_popup = false
	translation_container.visible = false
