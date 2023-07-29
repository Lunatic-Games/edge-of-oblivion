extends Node


# ITEM SIGNALS
signal item_setup_completed(item: Item)
signal item_update_triggered(item: Item)
signal item_tier_increased(item: Item)
signal item_tier_increased_simulate(item: Item)

# TILE SIGNALS
signal tile_update_triggered(tile: Tile)

# ENTITY SIGNALS
signal entity_update_triggered(entity: Occupant)
signal entity_damaged(source_item: Item, source_entity: Unit, source_tile: Tile,
	receiver_entity: Unit, damage_amount: int, was_killing_blow: bool)
signal entity_healed(healer_item: Item, healer_entity: Unit, healer_tile: Tile,
	receiver_entity: Unit, heal_amount: int)
