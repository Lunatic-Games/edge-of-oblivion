class_name Enemy
extends Entity


var gold_storage: GoldStorage = null

@onready var attack_bar: AttackBar = $AttackBar


func setup(p_data: EntityData, start_tile: Tile = null) -> void:
	super.setup(p_data, start_tile)
	
	var enemy_data: EnemyData = p_data as EnemyData
	if enemy_data.gold_storage_data != null:
		gold_storage = GoldStorage.new(self, enemy_data.gold_storage_data)
	
	if health != null:
		health.died.connect(_on_died)


func appear_ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate:a", 1.0, 0.2)


func appear_unready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate:a", 0.4, 0.2)


func _on_died(source: int = 0):
	var player: Player = GlobalGameState.get_player()
	if player == null:
		return
	
	var enemy_data: EnemyData = data as EnemyData
	
	if source == HealthData.SourceOfDamage.NORMAL:
		player.levelling.gain_xp(enemy_data.xp_value)
	
	GlobalSignals.enemy_killed.emit(self)
	if enemy_data.boss_data != null:
		GlobalSignals.boss_defeated.emit(self)
