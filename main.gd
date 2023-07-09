extends Node2D

@onready var deck = $Deck
@onready var players = $Players
@onready var dealer = $DealerHand
@onready var discard = $Discard
@onready var end_hand_button: Button = $EndHandButton
@onready var new_hand_button: Button = $NewHandButton

var MAX_PLAYERS = 4

enum State {
	CARD_PHASE,
	COLLECTION_PHASE
}

@onready var current_state: State = State.CARD_PHASE

# List of indices of seats with active players
var active_seats = []
var chips = 50
var complaints = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_chips(50)
	deck.init_deck()
	for player in players.get_children():
		var id = player.get_index()
		if id < 2:
			player.flip_arm()
		player.stack.deal_button_pressed.connect(_on_deal_button_pressed.bind(id))
		player.stack.clear_button_pressed.connect(_on_clear_button_pressed.bind(id))
	
		player.betting_area.add_button_pressed.connect(_on_bet_add_button_pressed.bind(id))
		player.betting_area.collect_button_pressed.connect(_on_bet_collect_button_pressed.bind(id))
		player.player_left.connect(_on_player_left.bind(id))
		player.dealer_hand = $DealerHand
	dealer.deal_button_pressed.connect(_on_dealer_deal_button_pressed)
	dealer.clear_button_pressed.connect(_on_dealer_clear_button_pressed)
	end_hand_button.pressed.connect(_end_hand_button_pressed)
	new_hand_button.pressed.connect(_new_hand_button_pressed)
	
	await get_tree().create_timer(3.0).timeout
	activate_random_player()
	start_hand()

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
	set_chips(chips - 1)
	
func _on_bet_collect_button_pressed(id):
	var amount = players.get_child(id).clear_chips()
	set_chips(chips + amount)

func _on_player_left(complaint, id):
	$PlayerSprites.get_child(id).visible = false
	if complaint:
		complaints += 1
		if complaints >= 5:
			end_game("Too many customers complained...")

func activate_random_player():
	if active_seats.size() >= MAX_PLAYERS:
		pass
	# choose an unactivated seat
	var unactivated = range(4).filter(func(id): return id not in active_seats)
	var chosen_id = unactivated.pick_random()
	# activate the sprite and controller for that player
	$PlayerSprites.get_child(chosen_id).visible = true
	var player = players.get_child(chosen_id)
	player.chips = range(8, 15).pick_random()
	player.activate()

func set_chips(amount):
	chips = amount
	$BankLabel.text = "Bank: $" + str(amount * 50)
	if chips <= 0:
		end_game("You lost all the casino's money...")
	
func deal_card() -> String:
	if(deck.is_empty()):
		print("deck is empty!")
		deck.add_cards(discard.take_all())
		deck.shuffle()
	return deck.take_card()

func start_hand():
	end_hand_button.disabled = false
	new_hand_button.disabled = true
	current_state = State.CARD_PHASE
	GlobalEvents.hand_start.emit()

func end_hand():
	end_hand_button.disabled = true
	new_hand_button.disabled = false
	GlobalEvents.hand_end.emit()

func end_game(label):
	$GameOverScreen.visible = true
	$GameOverScreen/Background/Description.text = label

func _end_hand_button_pressed():
	end_hand()
	
func _new_hand_button_pressed():
	#TODO: make sure everything is cleared before we allow the dealer to restart
	start_hand()


func _on_player_timer_timeout():
	activate_random_player()



func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

