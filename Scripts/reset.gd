extends PanelContainer

var GAME = load("res://Scenes/game.tscn")
@onready var lblTitle: Label = $VBoxContainer/Panel/HBoxContainerHead/lblTitle
@onready var label: Label = $VBoxContainer/HBoxContainerBody/VBoxContainerLeft/Control/Label
@onready var sprite: AnimatedSprite2D = $VBoxContainer/HBoxContainerBody/VBoxContainerMiddle/Control/AnimatedSprite2D
@onready var lblPlayerStats: Label = $VBoxContainer/HBoxContainerBody/VBoxContainerMiddle/lblPlayerStats
@onready var lblStats: Label = $VBoxContainer/HBoxContainerBody/VBoxContainerRight/Control/lblStats



func _ready() -> void:
	sprite.animation = str(Globals.playerSkin)
	label.text = "Resources\n" + str(Globals.silverBank) + " Silver\n" + str(Globals.goldBank) + " Gold\n" + str(Globals.diamondBank) + " Diamonds\n" + str(Globals.emeraldBank) + " Emeralds"
	lblPlayerStats.text = "HP: " + str(Globals.playerHealth) + "\nDamage: " + str(Globals.playerDamage) + "\nHit Chance: " + str(Globals.playerHitChance) + "\nPower up: \n" + str(Globals.powerUpActive)
	lblStats.text = "Stats\n" + "Resets: " + str(Globals.resets) + "\nKills: " + str(Globals.kills) + "\nHighest Level: " + str(Globals.highestLevel)
	
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME)
	Globals.playerHealth = Globals.baseHealth


func _on_btnQuit_pressed() -> void:
	get_tree().quit()
