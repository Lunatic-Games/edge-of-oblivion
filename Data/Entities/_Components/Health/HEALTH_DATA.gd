class_name HealthData
extends Resource


@export var max_health: int = 20
@export var can_be_damaged: bool = true
@export var can_be_killed: bool = true
@export var can_be_healed: bool = true

@export_group("VFX")
@export var emit_particles_on_heal: bool = true
@export var emit_particles_on_taking_damage: bool = true
