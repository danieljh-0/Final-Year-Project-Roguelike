extends PanelContainer

var GAME = load("res://Scenes/game.tscn")
var MENU = load("res://Scenes/menu.tscn")

#@onready var player: CharacterBody2D = $Player
const PLAYER = preload("res://Scenes/player.tscn")
@onready var label: Label = $VBoxContainer/Label



func _on_btn_restart_pressed() -> void:
	
	#RESET GLOBALS
	Globals.level = 1
	Globals.playerHealth = 12
	Globals.playerDamage = 4
	Globals.playerHitChance = 0.75
	Globals.powerUpActive = null
	Globals.powerUpUsed = false
	
	Globals.silver = 0
	Globals.silverBank = 0
	Globals.gold = 0
	Globals.goldBank = 0
	Globals.diamond = 0
	Globals.diamondBank = 0
	Globals.emerald = 0
	Globals.emeraldBank = 0
	
	Globals.kills = 0
	Globals.highestLevel = 0
	Globals.resets = 0
	Globals.file = ""
	Globals.win = false

	get_tree().call_deferred("change_scene_to_packed", MENU)
	
func _on_btn_quit_pressed() -> void:
	get_tree().quit()


func _on_ready() -> void:
	Globals.updateFile(Globals.file) #update file on end of game
	if Globals.win == true:
		label.text = "YOU WIN!!"
