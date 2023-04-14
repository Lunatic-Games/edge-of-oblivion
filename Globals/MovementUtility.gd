extends Node

enum MoveDirection {  # If updated, make sure to also update TileDirection in Tile.gd
	LEFT,
	RIGHT,
	UP,
	DOWN,
	NULL
}

enum CauseOfMove {
	INPUT,
	OTHER
}

var last_player_direction: MoveDirection = MoveDirection.NULL

func reset():
	last_player_direction = MoveDirection.NULL


# MoveRecord
#   To be used by Unit.gd; every time a unit moves, data about the move should be recorded
class MoveRecord:
	var from_tile: Tile
	var to_tile: Tile
	var direction: MoveDirection  # Optional direction; input when applicable
	var cause: CauseOfMove  # Optional cause; for identifying types of movement
	
	func _init(from: Tile,to: Tile, move_direction: MoveDirection = MoveDirection.NULL,
			cause_of_movement: CauseOfMove = CauseOfMove.OTHER):
		from_tile = from
		to_tile = to
		direction = move_direction
		cause = cause_of_movement


class MoveHistory:
	var _max_records: int
	var _history: Array[MoveRecord]  # Oldest records are at the highest index; newest record is _history[0]
		
	func _init(max_records: int = 10):
		_max_records = max_records
	
	func record(move_record: MoveRecord) -> void:
		_history.push_front(move_record)
		if _history.size() >= _max_records:
			_history.pop_back()
	
	func get_record(back_index: int) -> MoveRecord:
		assert(back_index < _history.size()) #,"ERROR [MovementUtility] Try subtracting 1 from index in get_record(index) call to MoveHistory")
		return _history[back_index]
	
	func overwrite_record(back_index: int, new_record: MoveRecord) -> void:
		assert(back_index < _history.size()) #,"ERROR [MovementUtility] Try subtracting 1 from index in overwrite_record(index, ...) call to MoveHistory")
		_history[back_index] = new_record
