extends Node


signal save_loaded

signal run_started
signal run_ended(is_victory: bool)
signal main_menu_entered
signal new_round_started

signal player_spawned(player: Player)
signal player_died(player: Player)
signal player_levelled_up(player: Player)
signal player_finished_moving(player: Player)
signal player_healed(player: Player, amount: int)

signal item_added_to_inventory(item: Item, item_data: ItemData)
signal item_increased_tier(item: Item, item_data: ItemData)
signal item_reached_max_tier(item: Item, item_data: ItemData)

signal enemy_turn_started
signal enemy_killed(enemy: Enemy)
signal enemy_spawning_finished

signal boss_spawned(boss: Enemy)
signal boss_defeated(boss: Enemy)
