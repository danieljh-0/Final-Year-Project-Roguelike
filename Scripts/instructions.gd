extends PanelContainer

@onready var panel: PanelContainer = $"."
@onready var label1: Label = $VBoxContainer/Control/Label1
@onready var label3: Label = $VBoxContainer/Control/Label3
@onready var icons: Control = $VBoxContainer/HBoxContainer/Icons
@onready var label2: Label = $VBoxContainer/HBoxContainer/Label2
@onready var page: Label = $VBoxContainer/HBoxContainer/HBoxContainer/page

func _ready() -> void:
	label1.visible = true
	label3.visible = false 
	icons.visible = true
	label2.visible = true
	page.text = "1 / 2"


func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	panel.visible = false


func _on_btnRight_pressed() -> void:
	label1.visible = false
	label3.visible = true 
	icons.visible = false
	label2.visible = false
	page.text = "2 / 2"
	

func _on_btnLeft_pressed() -> void:
	label1.visible = true
	label3.visible = false 
	icons.visible = true
	label2.visible = true
	page.text = "1 / 2"
