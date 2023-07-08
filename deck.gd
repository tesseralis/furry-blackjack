extends Node2D

# Represents the current deck of cards

var deck = []
var CARD_HEIGHT = 1
var NUM_DECKS = 6
var FULL_DECK_COUNT = 52 * NUM_DECKS

# Called when the node enters the scene tree for the first time.
func _ready():
	set_shoe_height()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_deck():
	deck = create_deck()
	set_shoe_height()
	
func set_shoe_height():
	var height = CARD_HEIGHT * deck.size()
	$Shoe.set_size(Vector2(80, height))

# deal the next card in the deck
func take_card():
	var card = deck.pop_back()
	set_shoe_height()
	return card

func add_cards(cards):
	deck.append_array(cards)
	set_shoe_height()

func create_deck():
	var suit = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
	var deck = dupe_array(suit, 4)
	var decks = dupe_array(deck, NUM_DECKS)
	decks.shuffle()
	return decks

func dupe_array(arr, count):
	var res = []
	for _i in range(count):
		res.append_array(arr)
	return res
