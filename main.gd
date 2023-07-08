extends Node2D

@onready var deck = $Deck
@onready var players = $Players
@onready var dealer = $DealerHand
@onready var discard = $Discard

# Called when the node enters the scene tree for the first time.
func _ready():
	deck.init_deck()
	for player in players.get_children():
		var id = player.get_index()
		player.stack.deal_button_pressed.connect(_on_deal_button_pressed.bind(id))
		player.stack.clear_button_pressed.connect(_on_clear_button_pressed.bind(id))
	
		player.betting_area.add_button_pressed.connect(_on_bet_add_button_pressed.bind(id))
		player.betting_area.collect_button_pressed.connect(_on_bet_collect_button_pressed.bind(id))
		
	dealer.deal_button_pressed.connect(_on_dealer_deal_button_pressed)
	dealer.clear_button_pressed.connect(_on_dealer_clear_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dealer_deal_button_pressed():
	var card_value = deal_card()
	dealer.add_card(card_value)
	for player in players.get_children():
		player.set_dealer_card(dealer.get_public_card())
	
	
func _on_dealer_clear_button_pressed():
	var card_values = dealer.clear_cards()
	discard.add_cards(card_values)
	for player in players.get_children():
		player.set_dealer_card(0)


func _on_deal_button_pressed(id):
	var card_value = deal_card()
	players.get_child(id).stack.add_card(card_value)


func _on_clear_button_pressed(id):
	var card_values = players.get_child(id).stack.clear_cards()
	discard.add_cards(card_values)
	
func _on_bet_add_button_pressed(id):
	players.get_child(id).betting_area.add_chips(1)
	
func _on_bet_collect_button_pressed(id):
	# TODO keep track of dealer's chips?
	players.get_child(id).betting_area.clear_chips()
	
func deal_card() -> String:
	if(deck.is_empty()):
		print("deck is empty!")
		deck.add_cards(discard.take_all())
		deck.shuffle()
	return deck.take_card()
