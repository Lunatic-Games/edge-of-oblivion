extends Button


const EXTRA_SPACING: float = 20.0
const FADE_MODULATE_TIME_SECONDS: float = 0.3
const BRING_IN_TIME_SECONDS: float = 0.1
const BRING_OUT_TIME_SECONDS: float = 0.3
const BRING_IN_DISTANCE: float = 20.0

# Keep track of them so they can be cancelled early if needed
var modulate_tween: Tween = null
var separation_tween: Tween = null

@onready var arrow_container: BoxContainer = $ArrowContainer


func _ready() -> void:
	arrow_container.set("theme_override_constants/separation", EXTRA_SPACING + size.x)
	arrow_container.modulate.a = 0.0


func fade_in_arrows():
	if modulate_tween != null and modulate_tween.is_valid():
		modulate_tween.kill()
	
	modulate_tween = create_tween()
	modulate_tween.tween_property(arrow_container, "modulate:a",
		1.0, FADE_MODULATE_TIME_SECONDS).set_trans(Tween.TRANS_CUBIC)


func fade_out_arrows():
	if modulate_tween != null and modulate_tween.is_valid():
		modulate_tween.kill()
	
	modulate_tween = create_tween()
	modulate_tween.tween_property(arrow_container, "modulate:a",
		0.0, FADE_MODULATE_TIME_SECONDS).set_trans(Tween.TRANS_CUBIC)


func bring_arrows_in():
	if separation_tween != null and separation_tween.is_valid():
		separation_tween.kill()
	
	separation_tween = create_tween()
	separation_tween.tween_property(arrow_container, "theme_override_constants/separation",
		EXTRA_SPACING + size.x - BRING_IN_DISTANCE, BRING_IN_TIME_SECONDS).set_trans(Tween.TRANS_CUBIC)


func bring_arrows_out():
	if separation_tween != null and separation_tween.is_valid():
		separation_tween.kill()
	
	separation_tween = create_tween()
	separation_tween.tween_property(arrow_container, "theme_override_constants/separation",
		EXTRA_SPACING + size.x, BRING_OUT_TIME_SECONDS).set_trans(Tween.TRANS_CUBIC)


func _on_focus_entered() -> void:
	fade_in_arrows()


func _on_mouse_entered() -> void:
	fade_in_arrows()


func _on_focus_exited() -> void:
	fade_out_arrows()


func _on_mouse_exited() -> void:
	fade_out_arrows()


func _on_button_down() -> void:
	bring_arrows_in()


func _on_button_up() -> void:
	bring_arrows_out()
