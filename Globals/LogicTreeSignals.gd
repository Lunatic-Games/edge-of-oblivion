extends Node


# ITEM SIGNALS
signal item_setup_completed(item: Item)
signal item_update_triggered(item: Item)
signal item_tier_increased(item: Item)

# TILE SIGNALS
signal tile_update_triggered(tile: Tile)

# ENTITY SIGNALS
signal entity_update_triggered(entity: Entity)
signal entity_damaged(source_item: Item, source_entity: Entity, source_tile: Tile,
	receiver_entity: Entity, damage_amount: int, was_killing_blow: bool)
signal entity_healed(healer_item: Item, healer_entity: Entity, healer_tile: Tile,
	receiver_entity: Entity, heal_amount: int)
