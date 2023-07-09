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
	GlobalEvents.hand_end.connect(_on_hand_end)
	GlobalEvents.hand_start.connect(_on_hand_start)
	update_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO how to handle "face down" card?
func add_card(card_value):
	$DealAudio.play()
	# Add the card and change the offset
	var card = card_scene.instantiate()
	if cards.get_child_count() == 0:
		card.set_facedown(true)
	else:
		card.set_facedown(false)
	card.set_value(card_value)
	card.position = card_pos
	card_pos += offset
	cards.add_child(card)
	update_label()

func clear_cards():
	$PickupAudio.play()
	var card_values = []
	for card in cards.get_children():
		card_values.append(card.value)
		card.queue_free()
	card_pos = Vector2.ZERO
	card_value_label.text = "0"
	if card_values.size() < 2:
		GlobalEvents.rule_broken.emit()
	return card_values

func update_label():
	card_value_label.text = str(HitStrategy.sum(get_card_values()))

func get_card_values() -> Array:
	return cards.get_children().map(func(child): return child.get_int_value())

func get_public_card() -> int:
	if cards.get_children().size() < 2:
		return 0
	return cards.get_child(1).get_int_value()

func _on_hand_end():
	$DealButton.disabled = true
	$ClearButton.disabled = false
	
func _on_hand_start():
	$DealButton.disabled = false
	$ClearButton.disabled = true

func _on_deal_button_pressed():
	deal_button_pressed.emit()


func _on_clear_button_pressed():
	clear_button_pressed.emit()

