extends Node2D

@onready var background = $Background
@onready var text = $Text

func show_text(display_text: String):
	text.text = display_text
	background.visible = true
	text.visible = true
	
func hide_text():
	background.visible = false
	text.visible = false
