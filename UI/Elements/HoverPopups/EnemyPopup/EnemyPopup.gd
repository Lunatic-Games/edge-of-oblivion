extends Button

const POPUP_OFFSET = Vector2(-10, -10)
const SCREEN_BORDER_PADDING = Vector2(32, 32)
const DELAY_IN_SECONDS: float = 0.5

@export var enemy: Enemy

var time_hovered_in_seconds: float = 0.0
var is_hovered: bool = false
var is_popup_spawned: bool = false

@onready var popup: PanelContainer = $PopupBorderContainer
@onready var panel: PanelContainer = $PopupBorderContainer
@onready var popup_text: RichTextLabel = $PopupBorderContainer/BackgroundPanel/VBoxContainer/PanelContainer/InfoText
@onready var popup_flavor_text: RichTextLabel = $PopupBorderContainer/BackgroundPanel/VBoxContainer/PanelContainer2/FlavorText
@onready var animator: AnimationPlayer = $AnimationPlayer


func _on_mouse_entered() -> void:
	is_hovered = true


func _on_mouse_exited() -> void:
	remove_text_popup()
	time_hovered_in_seconds = 0
	is_hovered = false


func _process(delta:float) -> void:
	if is_hovered && !is_popup_spawned:
		time_hovered_in_seconds += delta
		if time_hovered_in_seconds >= DELAY_IN_SECONDS:
			spawn_popup()


func spawn_popup() -> void:
	popup_text.text = enemy.data.get_full_main_text()
	popup_flavor_text.text = enemy.data.flavor_text
	
	is_popup_spawned = true
	popup.global_position = get_global_mouse_position() - panel.size + POPUP_OFFSET
	
	var canvas_transform: Transform2D = get_canvas_transform()
	var canvas_origin: Vector2 = canvas_transform.get_origin()
	var canvas_scale: Vector2 = canvas_transform.get_scale()
	var canvas_top_left: Vector2 = (-canvas_origin / canvas_scale)
	var left_border: float = canvas_top_left.x + SCREEN_BORDER_PADDING.x
	var top_border: float = canvas_top_left.y + SCREEN_BORDER_PADDING.y
	
	if popup.global_position.x < left_border:
		popup.global_position.x = left_border
	if popup.global_position.y < top_border:
		popup.global_position.y = top_border
	
	animator.play("fade_in")


func remove_text_popup() -> void:
	is_popup_spawned = false
	animator.play("fade_out")
