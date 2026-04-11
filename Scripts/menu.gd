extends PanelContainer

const GAME = preload("res://Scenes/game.tscn")
const SETTINGS = preload("res://Scenes/settings.tscn")
@onready var skin: AnimatedSprite2D = $VBoxContainer/CenterContainer/HBoxContainer/HBoxContainer/Control/AnimatedSprite2D
@onready var stats: Label = $VBoxContainer/CenterContainer/HBoxContainer/HBoxContainer/stats
var skinNumber = 0


func _on_ready() -> void:
	if Globals.file == "":
		var fileNumber = 0
		var path = "user://file" + str(fileNumber) + ".txt"
	
		while FileAccess.file_exists(path): 
			fileNumber += 1
			path = "user://file" + str(fileNumber) + ".txt"
				
		var oldFileNumber = fileNumber - 1
		if FileAccess.file_exists("user://file" + str(oldFileNumber) + ".txt"): 
			var file = FileAccess.open("user://file" + str(oldFileNumber) + ".txt", FileAccess.READ)
			var fileArray= []
			while not file.eof_reached():
				fileArray.append(file.get_line())
			if int(fileArray[1]) > 0: #health > 0, can continue game
				path = "user://file" + str(oldFileNumber) + ".txt"
				Globals.level = int(fileArray[0])
				Globals.playerHealth = int(fileArray[1])
				Globals.playerShield = int(fileArray[2])
				Globals.silverBank = int(fileArray[4])
				Globals.goldBank = int(fileArray[6])
				Globals.diamondBank = int(fileArray[8])
				Globals.emeraldBank = int(fileArray[10])
				
				if (fileArray[12]) != "true" && (fileArray[11]) != "<null>":
					Globals.powerUpActive = (fileArray[11])
				
				Globals.resets = int(fileArray[13])
				Globals.kills = int(fileArray[14])
				Globals.highestLevel = int(fileArray[15])
				
				
		Globals.updateFile(path) #initialise file
		Globals.file = path
		print(Globals.file)
		


func _on_btn_start_pressed() -> void:
	Globals.playerSkin = skinNumber
	match skinNumber:
		0:
			Globals.baseHealth = Globals.knightHp
		1:
			Globals.baseHealth = Globals.redWizardHp
		2:
			Globals.baseHealth = Globals.barbarianHp
		3:
			Globals.baseHealth = Globals.blueWizardHp
	get_tree().change_scene_to_packed(GAME);


func _on_btn_quit_pressed() -> void:
	get_tree().quit()
	
	
func _on_btn_left_pressed() -> void:
	if skinNumber > 0:
		Globals.playerSkin -= 1
		skinNumber -= 1
		skin.animation = str(skinNumber)
	else:
		Globals.playerSkin = 3
		skinNumber = 3
		skin.animation = str(skinNumber)
	match skinNumber:
			0:		
				stats.text = "HP: " + str(Globals.knightHp) + "\nDamage: " + str(Globals.knightDamage) + "\nHit Chance: " + str(int(100 * Globals.knightHitChance)) + "%"
				Globals.playerHealth = Globals.knightHp
			1:
				stats.text = "HP: " + str(Globals.redWizardHp) + "\nDamage: " + str(Globals.redWizardDamage) + "\nHit Chance: " + str(int(100 * Globals.redWizardHitChance)) + "%"
				Globals.playerHealth = Globals.redWizardHp
			2:
				stats.text = "HP: " + str(Globals.barbarianHp) + "\nDamage: " + str(Globals.barbarianDamage) + "\nHit Chance: " + str(int(100 * Globals.barabarianHitChance)) + "%"
				Globals.playerHealth = Globals.barbarianHp
			3:
				stats.text = "HP: " + str(Globals.blueWizardHp) + "\nDamage: " + str(Globals.blueWizardDamage) + "\nHit Chance: " + str(int(100 * Globals.blueWizardHitChance)) + "%"
				Globals.playerHealth = Globals.blueWizardHp

func _on_btn_right_pressed() -> void:
	if skinNumber < 3:
		Globals.playerSkin += 1
		skinNumber += 1
		skin.animation = str(skinNumber)
	else:
		Globals.playerSkin = 0
		skinNumber = 0
		skin.animation = str(skinNumber)
	match skinNumber:
			0:		
				stats.text = "HP: " + str(Globals.knightHp) + "\nDamage: " + str(Globals.knightDamage) + "\nHit Chance: " + str(int(100 * Globals.knightHitChance)) + "%"
				Globals.playerHealth = Globals.knightHp
			1:
				stats.text = "HP: " + str(Globals.redWizardHp) + "\nDamage: " + str(Globals.redWizardDamage) + "\nHit Chance: " + str(int(100 * Globals.redWizardHitChance)) + "%"
				Globals.playerHealth = Globals.redWizardHp
			2:
				stats.text = "HP: " + str(Globals.barbarianHp) + "\nDamage: " + str(Globals.barbarianDamage) + "\nHit Chance: " + str(int(100 * Globals.barabarianHitChance)) + "%"
				Globals.playerHealth = Globals.barbarianHp
			3:
				stats.text = "HP: " + str(Globals.blueWizardHp) + "\nDamage: " + str(Globals.blueWizardDamage) + "\nHit Chance: " + str(int(100 * Globals.blueWizardHitChance)) + "%"
				Globals.playerHealth = Globals.blueWizardHp


func _on_btnSettings_pressed() -> void:
	get_tree().change_scene_to_packed(SETTINGS)
