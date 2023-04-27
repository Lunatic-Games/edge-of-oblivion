extends Node


signal item_setup_completed(item: Item)
signal item_update_triggered(item: Item)
signal item_tier_increased(item: Item)
signal item_dealt_damage(item: Item, receiver: Unit, amount: int, was_killing_blow: bool)
