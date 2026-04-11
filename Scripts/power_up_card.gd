extends PanelContainer

@onready var player: CharacterBody2D = $"../../Player"
@onready var powerUpImage: AnimatedSprite2D = $VBoxContainer/Panel/Control/powerUpImage
@onready var lblName: Label = $VBoxContainer/HBoxContainer/lblName
@onready var lblRarity: Label = $VBoxContainer/HBoxContainer/Control/lblRarity
@onready var icon_1: AnimatedSprite2D = $VBoxContainer/HBoxContainerStats/spriteWrapper/icon1
@onready var icon_2: AnimatedSprite2D = $VBoxContainer/HBoxContainerStats2/spriteWrapper/icon2
@onready var lbl_stat_1: Label = $VBoxContainer/HBoxContainerStats/lblStat1
@onready var lbl_stat_2: Label = $VBoxContainer/HBoxContainerStats2/lblStat2


func _ready() -> void:
	pass



func _on_button_pressed() -> void:
	self.queue_free()
	player.waitingForInput = true
	
	
func display(powerUp: String) -> void:
	powerUpImage.animation = powerUp
	lblName.text = powerUp
	if powerUp == "Kingly Sword":
		lblRarity.text = "RARE"
		lblRarity.set("theme_override_colors/font_color",Color(0, 0.1, 0.9, 1))
	elif powerUp == "Crown of Ruin" || powerUp == "Gloves of Midas":
		lblRarity.text = "CURSED"
		lblRarity.set("theme_override_colors/font_color",Color(0.54, 0, 0, 1))
	else:
		lblRarity.text = "COMMON"
		lblRarity.set("theme_override_colors/font_color",Color(0, 0.5, 0.2, 1))
		
	match powerUp:
		"Iron Shield":
			icon_1.animation = "hp" 
			icon_2.visible = false
			lbl_stat_1.text = "+5 Shield"
			lbl_stat_2.text = ""
		"Golden Sword":
			icon_1.animation = "damage" 
			icon_2.animation = "hitChance" 
			lbl_stat_1.text = "+2 Damage"
			lbl_stat_2.text = "+5% Hit Chance"
		"Kingly Sword":
			icon_1.animation = "damage" 
			icon_2.visible = false
			lbl_stat_1.text = "+6 Damage"
			lbl_stat_2.text = ""
		"Warrior's Helm":
			icon_1.animation = "hp" 
			icon_2.animation = "hitChance" 
			lbl_stat_1.text = "+10 Shield"
			lbl_stat_2.text = "-10% Hit Chance"
		"Shadow Ring":
			icon_1.animation = "hitChance" 
			icon_2.visible = false
			lbl_stat_1.text = "-10% Enemy Hit Chance"
			lbl_stat_2.text = ""
		"Gloves of Midas":
			icon_1.animation = "resource" 
			icon_2.animation = "hp" 
			lbl_stat_1.text = "Double All Resources"
			lbl_stat_2.text = "Resource Pickup Costs 1 HP"
		"Crown of Ruin":
			icon_1.animation = "enemy" 
			icon_2.animation = "damage" 
			lbl_stat_1.text = "+1 Enemy Per Level"
			lbl_stat_2.text = "+3 Damage"
