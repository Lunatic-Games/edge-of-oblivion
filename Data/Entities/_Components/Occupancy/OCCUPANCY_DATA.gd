class_name OccupancyData
extends Resource


enum EntitySize {
	SMALL,
#	MEDIUM,
#	LARGE
}

enum BlockingBehavior {
	COLLECTABLE,
	STANDARD,
	IMMOVABLE
}

enum CollectableFilter {
	ANY,
	PLAYER,
	ENEMY
}

@export var size: EntitySize = EntitySize.SMALL
@export var blocking_behavior: BlockingBehavior = BlockingBehavior.STANDARD
@export var can_be_pushed_off_map: bool = true
@export var can_push_entities: bool = false
@export var collectable_filter: CollectableFilter = CollectableFilter.ANY


func can_be_collected(by: EntityData) -> bool:
	if blocking_behavior != BlockingBehavior.COLLECTABLE:
		return false
	
	match collectable_filter:
		CollectableFilter.PLAYER:
			return by is PlayerData
		CollectableFilter.ENEMY:
			return by is EnemyData
	return true


func can_be_knockbacked() -> bool:
	match blocking_behavior:
		BlockingBehavior.COLLECTABLE:
			return false
		BlockingBehavior.STANDARD:
			return true
		BlockingBehavior.IMMOVABLE:
			return false
	return false
