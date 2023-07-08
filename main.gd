extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Deck.init_deck()
	for stack in $Stacks.get_children():
		stack.deal_button_pressed.connect(_on_deal_button_pressed)
		stack.clear_button_pressed.connect(_on_clear_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_deal_button_pressed(id):
	var card_value = $Deck.take_card()
	$Stacks.get_child(id).add_card(card_value)


func _on_clear_button_pressed(id):
	var card_values = $Stacks.get_child(id).clear_cards()
	$Discard.add_cards(card_values)
	
