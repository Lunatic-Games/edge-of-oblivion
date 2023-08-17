@tool
class_name Spawner
extends Sprite2D


const TILEMAP_SIZE: int = 70


# To be called via call_group("spawner", "spawn_entity")
# Will be overriden by spawner classes
func spawn_entity() -> void:
	pass


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		set_notify_transform(true)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		position.x = snappedi(position.x, TILEMAP_SIZE)
		position.y = snappedi(position.y, TILEMAP_SIZE)
