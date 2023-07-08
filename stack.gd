extends Node2D

# Represents a player's current hand

@onready var card_scene = preload("res://card.tscn")
@onready var card_value_label = $CardValue
@onready var cards = $Cards

signal deal_button_pressed
signal clear_button_pressed
signal cards_updated(new_cards: Array)

@onready var offset = Vector2(35, 5)
@onready var card_pos = Vector2.ZERO 

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEvents.hand_end.connect(_on_hand_end)
	GlobalEvents.hand_start.connect(_on_hand_start)
	$DealButton.pressed.connect(_on_deal_button_pressed)
	$ClearButton.pressed.connect(_on_clear_button_pressed)
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
	cards_updated.emit(get_card_values())


func clear_cards():
	var card_values = []
	for card in cards.get_children():
		card_values.append(card.value)
		card.queue_free()
	card_pos = Vector2.ZERO
	card_value_label.text = "0"
	cards_updated.emit([])
	return card_values

func update_label():
	card_value_label.text = str(HitStrategy.sum(get_card_values()))
	
func get_card_values() -> Array:
	return cards.get_children().map(func(child): return child.get_int_value())

func _on_deal_button_pressed():
	deal_button_pressed.emit()


func _on_clear_button_pressed():
	clear_button_pressed.emit()

func _on_hand_end():
	$DealButton.disabled = true
	$ClearButton.disabled = false
	pass
	
func _on_hand_start():
	$DealButton.disabled = false
	$ClearButton.disabled = true
