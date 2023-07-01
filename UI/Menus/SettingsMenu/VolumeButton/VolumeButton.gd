extends "res://UI/Elements/MenuButton/MenuButton.gd"


const INCREMENT = 20  # Should be a divisor of 100

@export_enum("Master", "Music", "SFX") var audio_bus: String = "Master"

var current_volume_out_of_100: int = 100


func _ready() -> void:
	super._ready()
	
	var bus_index: int = AudioServer.get_bus_index(audio_bus)
	var linear_value: float = db_to_linear(AudioServer.get_bus_volume_db(bus_index)) * 100
	current_volume_out_of_100 = clampi(snappedi(linear_value, INCREMENT), 0, 100)
	text = str(current_volume_out_of_100) + "%"


func _pressed() -> void:
	current_volume_out_of_100 -= INCREMENT
	if current_volume_out_of_100 < 0:
		current_volume_out_of_100 = 100
	
	text = str(current_volume_out_of_100) + "%"
	
	var bus_index: int = AudioServer.get_bus_index(audio_bus)
	var db: float = linear_to_db(float(current_volume_out_of_100) / 100.0)
	AudioServer.set_bus_volume_db(bus_index, db)
	
