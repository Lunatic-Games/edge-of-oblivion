class_name MusicPlayer
extends AudioStreamPlayer


@export var tracks: Array[AudioStream] = []
@export_range(-80, 24, 1) var normal_volume_db: int = 0
@export_range(0, 10.0, 0.1, "or_greater") var time_to_fade_in_seconds: float = 1.0
@export_range(0, 10.0, 0.1, "or_greater") var time_to_fade_out_seconds: float = 1.0

const OFF_VOLUME_DB: int = -80

var current_track_index: int = -1
var fade_in_tween: Tween
var fade_out_tween: Tween


func _ready() -> void:
	volume_db = OFF_VOLUME_DB
	if autoplay:
		start_new_random_track(true)


func fade_in_volume() -> void:
	if fade_out_tween:
		fade_out_tween.stop()
		fade_out_tween = null
	
	fade_in_tween = create_tween()
	fade_in_tween.tween_property(self, "volume_db", 0, time_to_fade_in_seconds).set_trans(
		Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func fade_out_volume() -> void:
	if fade_in_tween:
		fade_in_tween.stop()
		fade_in_tween = null
	
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(self, "volume_db", OFF_VOLUME_DB, time_to_fade_out_seconds).set_trans(
		Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	fade_out_tween.finished.connect(_on_fade_out_tween_finished)


func start_new_random_track(fade_in: bool = false) -> void:
	if tracks.size() == 0:
		current_track_index = -1
		return
	
	if tracks.size() == 1:
		current_track_index = 0
	else:
		current_track_index = get_random_track_index_other_than_current()
	
	stream = tracks[current_track_index]
	
	if fade_in:
		fade_in_volume()
	else:
		volume_db = normal_volume_db
	play()


func _on_finished() -> void:
	# Don't start playing a new track if we are fading out, otherwise volume may get reset
	if fade_out_tween:
		return
	
	start_new_random_track()


func get_random_track_index_other_than_current() -> int:
	assert(tracks.size() > 1, "Can't get a different random track if there is less than 2!")
	
	var indices: Array[int] = []
	for index in tracks.size():
		indices.push_back(index)
	
	indices.erase(current_track_index)
	return indices.pick_random()


func _on_fade_out_tween_finished():
	stop()
