class_name GoldPickup
extends Entity


var gold_amount: int = 0


func setup(p_data: EntityData, start_tile: Tile = null) -> void:
	super.setup(p_data, start_tile)
	occupancy.collected.connect(_on_collected)


func _on_collected(by: Entity) -> void:
	if by is Player:
		var player: Player = by as Player
		var inventory: Inventory = player.inventory
		inventory.add_gold(gold_amount)
	elif by is Enemy:
		var enemy: Enemy = by as Enemy
		var storage: GoldStorage = enemy.gold_storage
		if storage != null and storage.data.stores_collected_gold:
			storage.add_collected_gold(gold_amount)

	animator.play("quick_despawn")
	await animator.animation_finished
	queue_free()
