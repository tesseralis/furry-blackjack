extends Node2D

# Represents a player's current hand

@export var card_scene: PackedScene

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
	# TODO offset the card's position
	add_child(card)
