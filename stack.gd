extends Node2D

# Represents a player's current hand

@onready var card_scene = preload("res://card.tscn")
@onready var card_value_label = $CardValue
@onready var cards = $Cards
signal deal_button_pressed(id)
signal clear_button_pressed(id)

@onready var offset = Vector2(35, 5)
@onready var card_pos = Vector2.ZERO 

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()

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
	cards.add_child(card)
	update_label()
	

func clear_cards():
	var card_values = []
	for card in cards.get_children():
		card_values.append(card.value)
		card.queue_free()
	card_pos = Vector2.ZERO
	card_value_label.text = "0"
	return card_values

func update_label():
	card_value_label.text = str(HitStrategy.sum(get_card_values()))
	
func get_card_values() -> Array:
	return cards.get_children().map(func(child): return child.get_int_value())

func _on_deal_button_pressed():
	deal_button_pressed.emit(get_index())


func _on_clear_button_pressed():
	clear_button_pressed.emit(get_index())

