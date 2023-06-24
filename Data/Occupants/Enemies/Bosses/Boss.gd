class_name Boss
extends Enemy


@export_placeholder("BOSS NAME") var display_name: String
@export var sound_track: AudioStream


func die() -> void:
	GlobalSignals.boss_defeated.emit(self)
	super.die()
