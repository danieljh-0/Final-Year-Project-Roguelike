extends Area2D

@onready var player: CharacterBody2D = $"../Player"
@onready var btn_next: Button = $"../Level 1/btnNext"
@onready var btn_return: Button = $"../Level 1/btnReturn"


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		btn_next.visible = true
		btn_next.position = Vector2(position.x - 19, position.y + 15)
		btn_return.visible = true
		btn_return.position = Vector2(position.x - 14, position.y - 38)


func _on_ready() -> void:
	if Globals.level % 3 == 1:
		position = Vector2(196, -4)
	elif Globals.level % 3 == 2:
		position = Vector2(172, 44)
	else:
		position = Vector2(196, -4)


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		btn_next.visible = false
		btn_return.visible = false
