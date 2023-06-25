extends Node


signal game_started
signal main_menu_entered
signal new_round_started

signal player_spawned(player: Player)
signal player_died(player: Player)
signal player_levelled_up(player: Player)
signal player_finished_moving(player: Player)

signal item_added_to_inventory(item: Item, item_data: ItemData)
signal item_increased_tier(item: Item, item_data: ItemData)
signal item_reached_max_tier(item: Item, item_data: ItemData)

signal boss_spawned(boss: Boss)
signal boss_defeated(boss: Boss)
