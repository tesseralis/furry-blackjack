extends Node2D

# Represents the dealer's current hand

@onready var card_scene = preload("res://card.tscn")
signal deal_button_pressed
signal clear_button_pressed

@onready var offset = Vector2(60, 0)
@onready var card_pos = Vector2.ZERO
@onready var cards = $Cards
@onready var card_value_label = $CardValue

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO how to handle "face down" card?
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
	deal_button_pressed.emit()


func _on_clear_button_pressed():
	clear_button_pressed.emit()

func get_public_card() -> int:
	if cards.get_children().is_empty():
		return 0
	return cards.get_child(0).get_int_value()
