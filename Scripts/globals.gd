extends Node

var level = 1
var playerSkin = 0
var file = ""

var playerHealth = 12
var playerShield = 0
var baseHealth = 0
var playerDamage = 4
var baseDamage = 0
var playerHitChance = 0.75
var baseHitChance = 0
var powerUpActive = null
var powerUpUsed = false

var silver = 0
var silverBank = 0
var gold = 0
var goldBank = 0
var diamond = 0
var diamondBank = 0
var emerald = 0
var emeraldBank = 0

var level1MaxX = 30
var level1MinX = -10
var level1MaxY = 15
var level1MinY = -15

#win conditions
var silverWin = 25
var goldWin = 20
var diamondWin = 10
var emeraldWin = 5

#playerStats
var knightHp = 12 
var knightDamage = 4
var knightHitChance = 0.65

var redWizardHp = 11
var redWizardDamage = 3
var redWizardHitChance = 0.95

var barbarianHp = 8
var barbarianDamage = 6
var barabarianHitChance = 0.65

var blueWizardHp = 16
var blueWizardDamage = 3
var blueWizardHitChance = 0.65

#enemy stats

var batHp = 4 
var batDamage = 2
var batHitChance = 1

var ghostHp = 3 
var ghostDamage = 4
var ghostHitChance = 0.66

var snakeHp = 6
var snakeDamage = 3
var snakeHitChance = 0.44

var witchHp = 8 
var witchDamage = 2
var witchHitChance = 0.5

#game stats
var resets = 0
var kills = 0
var highestLevel = 1
var win = false

#volume
var music = 100
var sfx = 100

func updateFile(path: String) -> void:
	var fileToUpdate = FileAccess.open(path, FileAccess.WRITE)
	#basic info
	fileToUpdate.store_string(str(Globals.level) + "\n") #0
	fileToUpdate.store_string(str(Globals.playerHealth) + "\n")
	fileToUpdate.store_string(str(Globals.playerShield) + "\n")
	#resources
	fileToUpdate.store_string(str(Globals.silver) + "\n") #3
	fileToUpdate.store_string(str(Globals.silverBank) + "\n")
	fileToUpdate.store_string(str(Globals.gold) + "\n")
	fileToUpdate.store_string(str(Globals.goldBank) + "\n")
	fileToUpdate.store_string(str(Globals.diamond) + "\n")
	fileToUpdate.store_string(str(Globals.diamondBank) + "\n")
	fileToUpdate.store_string(str(Globals.emerald) + "\n")
	fileToUpdate.store_string(str(Globals.emeraldBank) + "\n")
	#powerup
	fileToUpdate.store_string(str(Globals.powerUpActive) + "\n") #11
	fileToUpdate.store_string(str(Globals.powerUpUsed) + "\n")
	#stats
	fileToUpdate.store_string(str(Globals.resets) + "\n") #13
	fileToUpdate.store_string(str(Globals.kills) + "\n")
	fileToUpdate.store_string(str(Globals.highestLevel) + "\n")
	
