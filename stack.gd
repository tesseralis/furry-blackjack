extends Node2D

# Represents a player's current hand

var card_scene = load("res://card.tscn")
signal deal_button_pressed(id)

var offset = Vector2(10, 50)
var card_pos = Vector2(0, 30)
var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_card(card_value):
	# Add the card and change the offset
	var card = card_scene.instantiate()
	card.set_value(card_value)
	card.position = card_pos
	card_pos += offset
	# TODO offset the card's position
	add_child(card)


func _on_deal_button_pressed():
	deal_button_pressed.emit(id)
