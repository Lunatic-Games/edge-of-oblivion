extends Node2D

var baseTile = preload("res://Tile.tscn")
var playerScene = preload("res://Player.tscn")
var chestScene = preload("res://Chest.tscn")
var width = 6
var height = 6
var tileSpacing = 1

var unoccupiedTiles = []

onready var allTiles = []

func startGame():
	generateTiles()
	spawnPlayer()

func generateTiles():
	var index = 0
	
	for h in height:
		for w in width:
			var tile = spawnTile(w, h, index)
			index += 1
	
	unoccupiedTiles = allTiles

func spawnTile(w, h, index):
	var tile = baseTile.instance()
	tile.position.x += tile.get_child(0).get_rect().size.x*tile.get_child(0).scale.x  * w + w*tileSpacing
	tile.position.y += tile.get_child(0).get_rect().size.y*tile.get_child(0).scale.y * h + h*tileSpacing
	add_child(tile)
	allTiles.append(tile)
	
	if w > 0:
		tile.leftTile = allTiles[index-1]
		tile.leftTile.rightTile = tile
	
	if h > 0:
		tile.topTile = allTiles[index - width]
		tile.topTile.bottomTile = tile
	
	return tile

func spawnPlayer():
	var spawnIndex = randi()%(allTiles.size()+1)
	var player = playerScene.instance()
	player.currentTile = allTiles[spawnIndex]
	allTiles[spawnIndex].occupied = player
	player.position = allTiles[spawnIndex].position
	occupyTile(allTiles[spawnIndex], player)
	add_child(player)

func spawnChest():
	var spawnTile = getRandomUnoccupiedTile()
	var chest = chestScene.instance()
	chest.position = spawnTile.position
	chest.currentTile = spawnTile
	occupyTile(spawnTile, chest)
	add_child(chest)

func occupyTile(tile, occupant):
	tile.occupied = occupant
	var tileIndex = unoccupiedTiles.find(tile)
	unoccupiedTiles.remove(tileIndex)

func unoccupyTile(tile):
	tile.occupied = null
	unoccupiedTiles.append(tile)

func getRandomUnoccupiedTile():
	return unoccupiedTiles[randi()%(unoccupiedTiles.size())]
	
