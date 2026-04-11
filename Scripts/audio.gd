extends Node

@onready var coinPickup: AudioStreamPlayer = $"Coin Pickup"
@onready var healPickup: AudioStreamPlayer = $"Heal Pickup"
@onready var hit: AudioStreamPlayer = $Hit



func coinSound() -> void:
	coinPickup.play()
	
func healSound() -> void:
	healPickup.play()
	
func hitSound() -> void:
	hit.play()
