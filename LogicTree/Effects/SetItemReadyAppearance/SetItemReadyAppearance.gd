extends LogicTree


@export var item: Item
@export var appear_ready: bool = true


func _ready() -> void:
	assert(item != null, "Item not set")


func evaluate(targets: Array[Node]) -> bool:
	if appear_ready:
		item.appear_ready()
	else:
		item.appear_unready()
	
	return true
