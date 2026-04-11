extends Node

var coinScene = preload("res://Scenes/pickup.tscn")

@onready var level_1: TileMap = $"../Level 1/TileMap"
@onready var level_2: TileMap = $"../Level 1/TileMap2"
@onready var level_3: TileMap = $"../Level 1/TileMap3"
@onready var player: CharacterBody2D = $"../Player"

var map

func _ready() -> void:
	
	if Globals.level % 3 == 1:
		map = level_1
	elif Globals.level % 3 == 2:
		map = level_2
	elif Globals.level % 3 == 0:
		map = level_3
	
	var n = randi_range(2, 5)
	if Globals.level > 3:
		n += Globals.level
	
	for i in range(n):
		spawnCoin()
	player.enemyKilled.connect(spawnOnEnemyDeath)

	
func spawnCoin() -> void:
	var currentTile = Vector2(0.5, 0.5)
	var coin = coinScene.instantiate()
	var tileSize = 8
	var x = 0
	var y = 0
	
	
	while ((x == 0) && (y == 0)) || (is_wall((Vector2(x, y)))):
		x = randi_range(Globals.level1MinX, Globals.level1MaxX)
		y = randi_range(Globals.level1MinY, Globals.level1MaxY)

	
	currentTile = Vector2(x + 0.5, y + 0.5)
	coin.position = currentTile * tileSize
	
	var colour = randf_range(0, 1)
	if Globals.level < 3:
		colour = colour + 0.01
	else:
		colour = colour - (0.1 * pow(Globals.level, 0.5))
	
	if colour > 0.5:
		coin.get_child(0).animation = "silver"
	elif colour > 0.15:
		coin.get_child(0).animation = "gold"
	elif colour > 0:
		coin.get_child(0).animation = "diamond"
	else:
		coin.get_child(0).animation = "emerald"
	add_child(coin)
	
	

func spawnOnEnemyDeath(x: int, y: int) -> void:
	var currentTile = Vector2(x + 0.5, y + 0.5)
	var coin = coinScene.instantiate()
	var tileSize = 8
	coin.position = currentTile * tileSize
	var spawnType = randf()
	if spawnType <= 0.4:
		if Globals.level >= 4:
			if spawnType > 0.2:
				coin.get_child(0).animation = "diamond"
				add_child(coin)
	elif spawnType <= 0.65:
		coin.get_child(0).animation = "silver"
		add_child(coin)
	elif spawnType <= 0.85:
		coin.get_child(0).animation = "gold"
		add_child(coin)
	else:
		coin.get_child(0).animation = "heal"
		add_child(coin)	
	
	
	
func is_wall(tile_pos: Vector2) -> bool:
	var tile = map.get_cell_tile_data(0, tile_pos)
	if tile == null:
		return true
	return tile.get_custom_data("isWall") == true
