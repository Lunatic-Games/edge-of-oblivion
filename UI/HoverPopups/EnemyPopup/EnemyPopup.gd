extends Button

@export var enemy: Enemy

var delay: float = 0.75
var time_hovered: float = 0.0
var hovered: bool = false
var spawned_popup: bool = false

@onready var translation_container: Node2D = $TranslationContainer
@onready var panel: PanelContainer = $TranslationContainer/BackgroundPanel
@onready var popup_text: RichTextLabel = $TranslationContainer/BackgroundPanel/PanelContainer/InfoText

func _ready():
	var display_string = enemy.popup_info_text
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
			spawn_popup()

func spawn_popup():
	spawned_popup = true
	translation_container.global_position = get_global_mouse_position() + Vector2(-10, -10)
	translation_container.global_position -= panel.size
	
	var left_border = get_viewport().get_camera_2d().global_position.x - get_viewport_rect().size.x/2 + panel.size.x
	var top_border = get_viewport().get_camera_2d().global_position.y - get_viewport_rect().size.y/3 + panel.size.y
	
	if translation_container.global_position.x < left_border:
		translation_container.global_position.x = left_border
	if translation_container.global_position.y < top_border:
		translation_container.global_position.y = top_border
	
	translation_container.visible = true

func remove_text_popup():
	spawned_popup = false
	translation_container.visible = false
