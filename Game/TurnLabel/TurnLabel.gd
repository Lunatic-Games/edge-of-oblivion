extends Label


const FADE_TIME_SECONDS: float = 0.2


func _ready() -> void:
	GlobalSignals.new_round_started.connect(_on_new_round)
	GlobalSignals.enemy_turn_started.connect(_on_enemy_turn_started)


func _on_new_round():
	change_text("~YOUR TURN~")


func _on_enemy_turn_started():
	change_text("~ENEMY TURN~")


func change_text(new_text: String) -> void:
	var fade_out_tween: Tween = create_tween()
	fade_out_tween.tween_property(self, "modulate:a", 0, FADE_TIME_SECONDS / 2.0)
	await fade_out_tween.finished
	
	text = new_text
	
	var fade_in_tween: Tween = create_tween()
	fade_in_tween.tween_property(self, "modulate:a", 1, FADE_TIME_SECONDS / 2.0)
