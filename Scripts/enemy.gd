extends CharacterBody2D

@onready var level_1: TileMap = get_tree().get_root().get_node("Node2D/Level 1/TileMap")
@onready var level_2: TileMap = get_tree().get_root().get_node("Node2D/Level 1/TileMap2")
@onready var level_3: TileMap = get_tree().get_root().get_node("Node2D/Level 1/TileMap3")
@onready var player: CharacterBody2D = get_tree().get_root().get_node("Node2D/Player")
@onready var hp: Label = get_tree().get_root().get_node("Node2D/CanvasLayer/HP")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const GAME_OVER = preload("res://Scenes/gameOver.tscn")

var tileSize = 8
var x = 0
var y = 0
var map = level_1


#STATS
@export var enemyHp = 8 
@export var enemyDamage = 2
@export var enemyHitChance = 0.5
@export var enemyName = ""

var enemyTile


func _ready() -> void:


	if Globals.level % 3 == 1:
		map = level_1
	elif Globals.level % 3 == 2:
		map = level_2
	elif Globals.level % 3 == 0:
		map = level_3

	match sprite.animation:
		"bat":
			enemyHp = Globals.batHp
			enemyDamage = Globals.batDamage
			enemyHitChance = Globals.batHitChance
		"ghost":
			enemyHp = Globals.ghostHp
			enemyDamage = Globals.ghostDamage
			enemyHitChance = Globals.ghostHitChance
		"snake":
			enemyHp = Globals.snakeHp
			enemyDamage = Globals.snakeDamage
			enemyHitChance = Globals.snakeHitChance
		"witch":
			enemyHp = Globals.witchHp
			enemyDamage = Globals.witchDamage
			enemyHitChance = Globals.witchHitChance

		
	if Globals.level >= 4:
		var levelModifier = 4 * (Globals.level / 4)
		enemyHitChance = (1 - (0.5 / (1 + (0.2 * levelModifier)))) * (2 * enemyHitChance)
		@warning_ignore("integer_division")
		enemyHp = int(enemyHp * (0.5 + (Globals.level / 4)))
		@warning_ignore("integer_division")
		enemyDamage = enemyDamage * ((0.5 + (Globals.level / 4) * 0.75))
		
	if Globals.powerUpActive == "Shadow Ring":
		enemyHitChance = enemyHitChance - 0.1
		
	print("Enemy hp = " +  str(enemyHp))
	print("Enemy damage = " +  str(enemyDamage))
	print("Enemy hit chance = " + str(enemyHitChance))
	



func move() -> void:
	var direction = global_position.direction_to(player.global_position)
	var probability = randf()

	var distance = global_position.distance_to(player.global_position)

	if distance < 20:
		probability -= 0.5
	elif distance < 40:
		probability -= 0.35
	direction = direction.round()
	var nextPosition = position + direction * tileSize
	var target_tile = map.local_to_map(nextPosition)
	
	if probability < 0.5:
		if abs(direction.x) < abs(direction.y):
			direction = direction.round()
			direction.x = 0
			nextPosition = position + direction * tileSize
			target_tile = map.local_to_map(nextPosition)
		elif abs(direction.y) < abs(direction.x):
			direction = direction.round()
			direction.y = 0
			nextPosition = position + direction * tileSize
			target_tile = map.local_to_map(nextPosition)
		else:
			direction = direction.round()
			var flip = randi_range(0, 1)
			if flip == 0:
				direction.x = 0
			else:
				direction.y = 0
			nextPosition = position + direction * tileSize
			target_tile = map.local_to_map(nextPosition)
	

	elif probability >= 0.5:
		direction = direction.round()
		direction = Vector2(0, 1) #1
		nextPosition = position + direction * tileSize
		target_tile = map.local_to_map(nextPosition)
		if not is_wall(target_tile):
			direction = Vector2(0, 1)
		else:
			direction = Vector2(0, -1) #2
			nextPosition = position + direction * tileSize
			target_tile = map.local_to_map(nextPosition)
			if not is_wall(target_tile):
				direction = Vector2(0, -1)
			else:
				direction = Vector2(1, 0) #3
				nextPosition = position + direction * tileSize
				target_tile = map.local_to_map(nextPosition)
				if not is_wall(target_tile):
					direction = Vector2(1, 0)
				else:
					direction = Vector2(-1, 0) #4
					nextPosition = position + direction * tileSize
					target_tile = map.local_to_map(nextPosition)
					if not is_wall(target_tile):
						direction = Vector2(-1, 0)
	
	
	if not is_wall(target_tile):
		if Vector2(target_tile) != Vector2(player.playerTile):
			position = nextPosition
			enemyTile = target_tile
			setAnimation(direction)
		else:
			setAnimation(direction)
			damagePlayer()


func setAnimation(direction: Vector2) -> void:
	if direction.x == -1:
		sprite.animation = sprite.animation.get_slice("_", 0)
		sprite.animation = str(sprite.animation) + "_left"
	elif direction.x == 1:
		sprite.animation = sprite.animation.get_slice("_", 0)


func is_wall(tile_pos: Vector2) -> bool:
	var tile = map.get_cell_tile_data(0, tile_pos)
	if tile == null:
		return false
	return tile.get_custom_data("isWall") == true

func damagePlayer():
	if enemyHp > 0:
		var probability = randf()
		if probability <= enemyHitChance:
			print("Player damaged by " + enemyName)
			Audio.hitSound()
			if Globals.playerShield >= enemyDamage:
				Globals.playerShield -= enemyDamage
			elif Globals.playerShield > 0:
				player.playerHp -= (enemyDamage - Globals.playerShield)
				Globals.playerShield = 0
			else:
				player.playerHp -= enemyDamage
			Globals.playerHealth = int(player.playerHp)
			if player.playerHp <= 0:
				print("You died!")
				player.queue_free()
				get_tree().change_scene_to_packed(GAME_OVER)
		else:
			print(enemyName + " attacked but missed you\n")


func reset():
	enemyHp = 8;
