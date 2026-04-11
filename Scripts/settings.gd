extends PanelContainer


@onready var sfxSlider: HSlider = $VBoxContainer/HBoxContainer/VBoxContainer/SFX/HSliderSFX
@onready var musicSlider: HSlider = $VBoxContainer/HBoxContainer/VBoxContainer/Music/HSliderMusic
var MENU = load("res://Scenes/menu.tscn")

var sfxBus = AudioServer.get_bus_index("SFX")
var musicBus = AudioServer.get_bus_index("Music")

func _ready() -> void:
	sfxSlider.value = Globals.sfx
	musicSlider.value = Globals.music


func update() -> void:
	if Globals.sfx == 100:
		AudioServer.set_bus_volume_db(sfxBus, 0)
	elif Globals.sfx == 0:
		AudioServer.set_bus_volume_db(sfxBus, -60)
	else:
		var volume = 40 * (1 - log100(Globals.sfx))
		volume = 0 - volume
		AudioServer.set_bus_volume_db(sfxBus, volume)
		
	if Globals.music == 100:
		AudioServer.set_bus_volume_db(musicBus, 0)
	elif Globals.music == 0:
		AudioServer.set_bus_volume_db(musicBus, 60)
	else:
		var volume = 40 * (1 - log100(Globals.music))
		AudioServer.set_bus_volume_db(musicBus, volume)
	
	
func log100(x: float) -> float:
	var y = (log(x) / log(100))
	return y


func _on_button_pressed() -> void:
	Globals.sfx = sfxSlider.value
	Globals.music = musicSlider.value
	update()
	get_tree().change_scene_to_packed(MENU)


func _on_btnBack_pressed() -> void:
	get_tree().change_scene_to_packed(MENU)
