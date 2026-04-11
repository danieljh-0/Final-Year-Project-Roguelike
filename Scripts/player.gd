extends CharacterBody2D

@onready var level_1: TileMap = $"../Level 1/TileMap"
@onready var level_2: TileMap = $"../Level 1/TileMap2"
@onready var level_3: TileMap = $"../Level 1/TileMap3"
@onready var hp: Label = $"../CanvasLayer/HP"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game: Node2D = $".."
@onready var powerUp: Area2D = $"../PowerUp"
@onready var power: Control = $"../CanvasLayer/Power"
@onready var powerUpCard: PanelContainer = $"../CanvasLayer/powerUpCard"

const PLAYER = preload("res://Scenes/player.tscn")

var tileMap

var tileSize = 8
var playerTile = Vector2(0.5, 0.5)
var nextPosition = 0
var waitingForInput = true

signal enemyKilled(x, y)


#STATS
@export var playerHp = 12 
@export var playerDamage = 4
@export var hitChance = 0.65

func _ready() -> void:
	
	
	match Globals.playerSkin:
		0: #knight
			self.get_child(0).animation = "0"
			playerDamage = 4
			hitChance = 0.65
		1: #redwizard
			self.get_child(0).animation = "1"
			playerDamage = 3
			hitChance = 0.95
		2: #barbarian
			self.get_child(0).animation = "2"
			playerDamage = 6
			hitChance = 0.65
		3: #bluewizard
			self.get_child(0).animation = "3"
			playerDamage = 3
			hitChance = 0.65
	
	Globals.baseDamage = playerDamage
	Globals.baseHitChance = hitChance
	
			
	match Globals.powerUpActive:
		null:
			pass
		"Iron Shield":
			if not Globals.powerUpUsed:
				#playerHp += 5
				#Globals.playerHealth += 5
				Globals.powerUpUsed = true
		"Golden Sword":
			playerDamage += 2
			hitChance += 0.05
		"Shadow Ring":
			for enemy in get_tree().get_nodes_in_group("enemies"): #check if this works every time
				enemy.enemyHitChance -= 0.1
		"Warrior's Helm":
			if not Globals.powerUpUsed:
				#playerHp += 10
				#Globals.playerHealth += 10
				hitChance -= 0.1
				Globals.powerUpUsed = true
		"Kingly Sword":
			playerDamage += 6
		"Gloves of Midas":
			pass #coins x2, -1 hp per coin -> done through pickup script
		"Crown of Ruin":
			playerDamage += 3
			
	Globals.playerDamage = playerDamage
	Globals.playerHitChance = hitChance
	playerHp = Globals.playerHealth
	
	if Globals.level % 3 == 1:
		tileMap = level_1
		level_1.visible = true
		level_2.visible = false
		level_3.visible = false
	elif Globals.level % 3 == 2:
		tileMap = level_2
		level_1.visible = false
		level_2.visible = true
		level_3.visible = false
	elif Globals.level % 3 == 0:
		tileMap = level_3
		level_1.visible = false
		level_2.visible = false
		level_3.visible = true
	
	position = playerTile * tileSize
	playerTile = tileMap.local_to_map(position)
	hp = get_node("/root/Node2D/CanvasLayer/HP")
	hp.text = str(playerHp)
	

func _process(_delta: float) -> void:
	Globals.playerDamage = playerDamage
	if waitingForInput:
		handleInput()

func handleInput():
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("up"):
		direction = Vector2(0, -1)
	if Input.is_action_just_pressed("down"):
		direction = Vector2(0, 1)
	if Input.is_action_just_pressed("left"):
		direction = Vector2(-1, 0)
		sprite.animation = str(Globals.playerSkin) + "_left"
	if Input.is_action_just_pressed("right"):
		direction = Vector2(1, 0)
		sprite.animation = str(Globals.playerSkin)
	if Input.is_action_just_pressed("stay"):
		direction = Vector2.INF
	
	if direction != Vector2.ZERO && direction != Vector2.INF: #if moved
		try_move(direction)
		enemy_turns()
	elif direction != Vector2.ZERO:
		enemy_turns()
		
func try_move(direction: Vector2):
	nextPosition = position + direction * tileSize
	var targetTile = tileMap.local_to_map(nextPosition)
	var enemyToDamage = null
	if not is_wall(targetTile):
		var notEnemy = true
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if Vector2(targetTile) == Vector2(floor(enemy.enemyTile)):
				notEnemy = false
				enemyToDamage = enemy
		if notEnemy:
			position = nextPosition #move
			playerTile = targetTile
			if Vector2(playerTile) == game.powerTileMaths: #check for power ups
				if Globals.powerUpActive != null:
					playerDamage = Globals.baseDamage
					hitChance = Globals.baseHitChance
				waitingForInput = false
				var powerUpFound = str(powerUp.get_child(0).animation)
				powerUp.queue_free()
				Globals.powerUpActive = powerUpFound
				game.powerTileMaths = Vector2(10000, 10000) #move out the way
				powerUpCard.visible = true
				powerUpCard.display(powerUpFound)
				power.visible = true
				power.get_child(0).animation = powerUpFound
				power.get_child(1).text = powerUpFound
				match powerUpFound:
					null:
						pass
					"Iron Shield":
						#playerHp += 5
						#Globals.playerHealth += 5
						Globals.playerShield = 5
					"Golden Sword":
						playerDamage += 2
						hitChance += 0.05
					"Shadow Ring":
						for enemy in get_tree().get_nodes_in_group("enemies"): #check if this works every time
							enemy.enemyHitChance -= 0.1
					"Warrior's Helm":
						#playerHp += 10
						#Globals.playerHealth += 10
						Globals.playerShield = 10
						hitChance -= 0.1
					"Kingly Sword":
						playerDamage += 6
					"Gloves of Midas":
						pass #coins x2, -1 hp per coin
					"Crown of Ruin":
						playerDamage += 3
				powerUpFound = null
		else:
			damageEnemy(enemyToDamage)

func is_wall(pTile: Vector2) -> bool:
	var tile = tileMap.get_cell_tile_data(0, pTile) #get tile data
	if tile == null: #if theres no data treat as a wall
		return true
	return tile.get_custom_data("isWall") == true #check if its a wall

func enemy_turns():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.move()
		
func damageEnemy(enemy: Node2D):
	var probability = randf()
	if probability <= hitChance:
		print(enemy.enemyName + " damaged")
		enemy.enemyHp -= playerDamage
		print(enemy.enemyName + " HP: " + str(enemy.enemyHp))
		Audio.hitSound()
		if enemy.enemyHp <= 0:
			print(enemy.enemyName + " killed" + "\n")
			enemy.queue_free()
			Globals.kills += 1
			var enemyTile = tileMap.local_to_map(nextPosition)
			enemyKilled.emit(enemyTile.x, enemyTile.y)
	else:
		print("You missed the " + enemy.enemyName)
		print(enemy.enemyName + " HP: " + str(enemy.enemyHp) + "\n")
