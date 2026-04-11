extends Area2D

@onready var area_2d: Area2D = $"."
@onready var silver: Label = $"../../CanvasLayer/Silver"
@onready var gold: Label = $"../../CanvasLayer/Gold"
@onready var level_1: TileMap = $"../../Level 1/TileMap"
@onready var level_2: TileMap = $"../../Level 1/TileMap2"
@onready var level_3: TileMap = $"../../Level 1/TileMap3"
@onready var hp: Label = $"../../CanvasLayer/HP"
@onready var diamond: Label = $"../../CanvasLayer/Diamond"
@onready var emerald: Label = $"../../CanvasLayer/Emerald"
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer


var map = level_1
var tileSize = 8
var currentTile = Vector2(0.5, 0.5)
var x = 0
var y = 0
@onready var player: CharacterBody2D = $"../../Player"
var tileMaths = Vector2(x, y) 

func _ready() -> void:
	if Globals.level % 3 == 1:
		map = level_1
	elif Globals.level % 3 == 2:
		map = level_2
	elif Globals.level % 3 == 0:
		map = level_3
	
	silver.text = "Silver: " + str(Globals.silver)
	gold.text = "Gold: " + str(Globals.gold)
	diamond.text = "Diamond: " + str(Globals.diamond)
	emerald.text = "Emerald: " + str(Globals.emerald)


func _process(_delta: float) -> void:
	currentTile = position / tileSize
	currentTile = Vector2(currentTile.x - 0.5, currentTile.y - 0.5)
	if Vector2(currentTile) == Vector2(player.playerTile):
		if $AnimatedSprite2D.animation == "silver":
			if Globals.powerUpActive == "Gloves of Midas":
				Globals.silver += 2
				player.playerHp -= 1
				Globals.playerHealth -= 1
			else:
				Globals.silver += 1
			Audio.coinSound()
		elif $AnimatedSprite2D.animation == "gold":
			if Globals.powerUpActive == "Gloves of Midas":
				Globals.gold += 2
				player.playerHp -= 1
				Globals.playerHealth -= 1
			else:
				Globals.gold += 1
			Audio.coinSound()
		elif $AnimatedSprite2D.animation == "heal":
			player.playerHp += 4
			Globals.playerHealth = int(player.playerHp)
			print(hp)
			Audio.healSound()
		elif $AnimatedSprite2D.animation == "diamond":
			if Globals.powerUpActive == "Gloves of Midas":
				Globals.diamond += 2
				player.playerHp -= 1
				Globals.playerHealth -= 1
			else:
				Globals.diamond += 1
			Audio.coinSound()
		elif $AnimatedSprite2D.animation == "emerald":
			if Globals.powerUpActive == "Gloves of Midas":
				Globals.emerald += 2
				player.playerHp -= 1
				Globals.playerHealth -= 1
			else:
				Globals.emerald += 1
			Audio.coinSound()
		area_2d.queue_free()
		
func is_wall(tile_pos: Vector2) -> bool:
	var tile = map.get_cell_tile_data(0, tile_pos)
	if tile == null:
		return false
	return tile.get_custom_data("isWall") == true
