extends Button

const POPUP_OFFSET = Vector2(-10, -10)

@export var item: Item

var delay_in_seconds: float = 0.5
var time_hovered_in_seconds: float = 0.0
var is_hovered: bool = false
var is_popup_spawned: bool = false

@onready var translation_container: Node2D = $TranslationContainer
@onready var panel: PanelContainer = $TranslationContainer/BorderContainer
@onready var popup_text: RichTextLabel = $TranslationContainer/BorderContainer/BackgroundPanel/VBoxContainer/PanelContainer/InfoText
@onready var popup_flavor_text: RichTextLabel = $TranslationContainer/BorderContainer/BackgroundPanel/VBoxContainer/PanelContainer2/FlavorText
@onready var animator: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	popup_text.text = item.popup_info_text
	popup_flavor_text.text = item.popup_flavor_text


func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	remove_text_popup()
	time_hovered_in_seconds = 0
	is_hovered = false


func _process(delta:float) -> void:
	if is_hovered && !is_popup_spawned:
		time_hovered_in_seconds += delta
		if time_hovered_in_seconds >= delay_in_seconds:
			spawn_popup()


func spawn_popup() -> void:
	is_popup_spawned = true
	translation_container.global_position = get_global_mouse_position() + POPUP_OFFSET
	translation_container.global_position -= panel.size
	
	var camera: Camera2D = get_viewport().get_camera_2d()
	var viewport_size: Vector2 = get_viewport_rect().size
	var left_border: float = camera.global_position.x - viewport_size.x / 2 + panel.size.x
	var top_border: float = camera.global_position.y - viewport_size.y / 3 + panel.size.y # We divide by 3 here since the camera is represented as a 2x3 rectangle
	
	if translation_container.global_position.x < left_border:
		translation_container.global_position.x = left_border
	if translation_container.global_position.y < top_border:
		translation_container.global_position.y = top_border
	
	animator.play("fade_in")


func remove_text_popup() -> void:
	is_popup_spawned = false
	animator.play("fade_out")
