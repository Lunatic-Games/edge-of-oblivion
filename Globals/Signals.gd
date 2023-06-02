extends Node


signal game_started
signal main_menu_entered

signal player_died(player: Player)
signal player_levelled_up(player: Player)
signal player_finished_moving(player: Player)

signal boss_spawned(boss: Boss)
signal boss_defeated(boss: Boss)
