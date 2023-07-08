extends Node2D

# Represents the current deck of cards

var deck = []
var DECK_HEIGHT = 120
var NUM_DECKS = 6
var FULL_DECK_COUNT = 52 * NUM_DECKS

# Called when the node enters the scene tree for the first time.
func _ready():
	deck = create_deck()
	set_shoe_height()
	# TODO adjust size of rectangle based on size of deck

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# shuffle the deck with 6 decks of cards
func init():
	pass
	
func set_shoe_height():
	var height = DECK_HEIGHT * deck.size() / FULL_DECK_COUNT
	$Shoe.set_size(Vector2(32, height))

# deal the next card in the deck
func take_card():
	var card = deck.pop_back()
	set_shoe_height()
	return card

func create_deck():
	var suit = ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']
	var deck = dupe_array(suit, 4)
	var decks = dupe_array(deck, NUM_DECKS)
	decks.shuffle()
	return decks

func dupe_array(arr, count):
	var res = []
	for _i in range(count):
		res.append_array(arr)
	return res
