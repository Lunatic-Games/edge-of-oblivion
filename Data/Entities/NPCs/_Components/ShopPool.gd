class_name ShopPool
extends RefCounted


var entity: Entity = null
var data: ShopPoolData = null

var items: Array[ItemData] = []


func _init(p_entity: Entity, p_data: ShopPoolData):
	entity = p_entity
	data = p_data
	
	items = data.generate_selection()
