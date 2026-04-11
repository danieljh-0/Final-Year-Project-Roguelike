extends Node2D

@onready var tileMap: TileMap = $"Level 1/TileMap"
@onready var hp: Label = $CanvasLayer/HP
@onready var level: Label = $CanvasLayer/Level
@onready var silver: Label = $CanvasLayer/Silver
@onready var gold: Label = $CanvasLayer/Gold
@onready var diamond: Label = $CanvasLayer/Diamond
@onready var emerald: Label = $CanvasLayer/Emerald
@onready var btn_next: Button = $"Level 1/btnNext"
@onready var btn_return: Button = $"Level 1/btnReturn"
@onready var player: CharacterBody2D = $Player
@onready var powerUp: Area2D = $PowerUp
@onready var animatedSprite: AnimatedSprite2D = $"PowerUp/AnimatedSprite2D"
@onready var power: Control = $CanvasLayer/Power
@onready var damage: Label = $CanvasLayer/Damage
@onready var level_1: TileMap = $"Level 1/TileMap"
@onready var level_2: TileMap = $"Level 1/TileMap2"
@onready var level_3: TileMap = $"Level 1/TileMap3"
@onready var shieldSprite: AnimatedSprite2D = $CanvasLayer/HP/Control2/shieldSprite
@onready var lblShield: Label = $CanvasLayer/HP/Control2/lblShield


var GAME = load("res://Scenes/game.tscn")
var RESET = load("res://Scenes/reset.tscn")
var GAME_OVER = load("res://Scenes/gameOver.tscn")


var map = level_1
var powerTile = null
var powerTileMaths = null

func _ready() -> void:
	randomize()
	
	hp.text = " " + str(Globals.playerHealth)
	
	#powerups
	if Globals.powerUpActive != null:
		power.get_child(0).animation = Globals.powerUpActive
		power.get_child(1).text = Globals.powerUpActive
	else:	
		power.visible = false
		
	if Globals.level % 3 == 1:
		map = level_1
	elif Globals.level % 3 == 2:
		map = level_2
	elif Globals.level % 3 == 0:
		map = level_3
	
	var spawnChance = 0
	var random = randf()
	spawnChance = (0.1 * Globals.level) - 0.2
	if Globals.level == 3: #guaranteed powerup on level 3
		spawnChance = 1
	if random < spawnChance:
		powerUp.visible = true
		powerTile = Vector2(0.5, 0.5)
		var tileSize = 8
		var x = 0
		var y = 0
		
		
		while ((x == 0) && (y == 0)) || (is_wall((Vector2(x, y)))):
			x = randi_range(Globals.level1MinX, Globals.level1MaxX)
			y = randi_range(Globals.level1MinY, Globals.level1MaxY)
			
		var animation = randf()
		if animation >= 0.8:
			animatedSprite.animation = "Iron Shield"
		elif animation >= 0.6:
			animatedSprite.animation = "Golden Sword"
		elif animation >= 0.4:
			animatedSprite.animation = "Shadow Ring"
		elif animation >= 0.2:
			animatedSprite.animation = "Warrior's Helm"
		elif animation >= 0.12:
			animatedSprite.animation = "Kingly Sword"
		elif animation >= 0.05:
			animatedSprite.animation = "Gloves of Midas"
		else:
			animatedSprite.animation = "Crown of Ruin"
		
		powerTile = Vector2(x + 0.5, y + 0.5)
		powerTileMaths = Vector2(x, y)
		powerUp.position = powerTile * tileSize
		print("POWER UP SPAWNED")
		print(powerTileMaths)
		
		
func _process(_delta: float) -> void:
	#Set UI
	level.text = "Level: " + str(Globals.level)
	damage.text = "Damage: " + str(Globals.playerDamage)
	if Globals.playerShield <= 0:
		shieldSprite.visible = false
		lblShield.visible = false
		hp.text = str(Globals.playerHealth)
	else:
		shieldSprite.visible = true
		lblShield.visible = true
		hp.text = str(Globals.playerHealth)
		lblShield.text = str(int(Globals.playerShield))
	silver.text = str(Globals.silver)
	gold.text = str(Globals.gold)
	diamond.text = str(Globals.diamond)
	emerald.text = str(Globals.emerald)
	
	
func is_wall(tile_pos: Vector2) -> bool:
	var tile = map.get_cell_tile_data(0, tile_pos)
	if tile == null:
		return true
	return tile.get_custom_data("isWall") == true
	
	


func _on_btn_next_pressed() -> void:
	Globals.level += 1
	btn_next.visible = false
	btn_return.visible = false
	get_tree().call_deferred("change_scene_to_packed", GAME)
	#player.playerHp = Globals.playerHealth
	Globals.updateFile(Globals.file) #update file on next level
	


func _on_btn_return_pressed() -> void:
	Globals.resets += 1
	Globals.highestLevel = max(Globals.level, Globals.highestLevel)
	Globals.level = 1
	btn_next.visible = false
	btn_return.visible = false
	
	
	#bank resources
	Globals.silverBank += Globals.silver
	Globals.silver = 0
	Globals.goldBank += Globals.gold
	Globals.gold = 0
	Globals.diamondBank += Globals.diamond
	Globals.diamond =  0
	Globals.emeraldBank += Globals.emerald
	Globals.emerald =  0
	
	#check for win
	if Globals.silverBank >= Globals.silverWin:
		if Globals.goldBank >= Globals.goldWin:
			if Globals.diamondBank >= Globals.diamondWin:
				if Globals.emeraldBank >= Globals.emeraldWin:
					print("you win")
					Globals.win = true
					get_tree().change_scene_to_packed(GAME_OVER)
					Globals.playerHealth = -99 #ensures new file will be created next game, but marks as a win

	if !Globals.win: #normal reset
		get_tree().change_scene_to_packed(RESET)
		Globals.playerHealth = Globals.baseHealth
		
	Globals.updateFile(Globals.file) #update file on reset
	
	
