extends Node

var enemyScene = preload("res://Scenes/enemy.tscn")

@onready var level_1: TileMap = $"../Level 1/TileMap"
@onready var level_2: TileMap = $"../Level 1/TileMap2"
@onready var level_3: TileMap = $"../Level 1/TileMap3"

var tileSize = 8
var map = level_1


func _ready() -> void:
	
	if Globals.level % 3 == 1:
		map = level_1
	elif Globals.level % 3 == 2:
		map = level_2
	elif Globals.level % 3 == 0:
		map = level_3
		
	var enemyCount = 0
	if Globals.level <= 2:
		enemyCount = Globals.level
	else:
		if Globals.level % 3 == 1:
			enemyCount = 2
		elif Globals.level % 3 == 2:
			enemyCount = 3
		elif Globals.level % 3 == 0:
			enemyCount = 3
	
	if Globals.powerUpActive == "Crown of Ruin":
		enemyCount += 1
	
	for i in range(enemyCount):
		spawnEnemy()

func spawnEnemy() -> void:
	var x = 0
	var y = 0
	var enemy = enemyScene.instantiate()
	var enemyTile = Vector2(0.5, 0.5)
	var animation = randi_range(1, 4)
	match animation:
		1:
			enemy.get_child(0).animation = "bat"
			enemy.enemyName = "Bat"
		2:
			enemy.get_child(0).animation = "ghost"
			enemy.enemyName = "Ghost"
		3:
			enemy.get_child(0).animation = "snake"
			enemy.enemyName = "Snake"
		4:
			enemy.get_child(0).animation = "witch"
			enemy.enemyName = "Witch"
			
	enemy.add_to_group("enemies")
	while ((x == 0) && (y == 0)) || (is_wall(Vector2(x, y))):
		x = randi_range(Globals.level1MinX, Globals.level1MaxX)
		y = randi_range(Globals.level1MinY, Globals.level1MaxY)
	
	enemyTile = Vector2(x + 0.5, y + 0.5)
	enemy.enemyTile = enemyTile
	enemy.position = enemyTile * tileSize
	
	
	add_child(enemy)
	
func is_wall(tile_pos: Vector2) -> bool:
	var tile = map.get_cell_tile_data(0, tile_pos)
	if tile == null:
		return false
	return tile.get_custom_data("isWall") == true
