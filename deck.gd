extends Node2D

# Represents the current deck of cards

var deck = []

# Called when the node enters the scene tree for the first time.
func _ready():
	deck = create_deck()
	# TODO adjust size of rectangle based on size of deck

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# shuffle the deck with 6 decks of cards
func init():
	pass

# deal the next card in the deck
func take_card():
	return deck.pop_back()

func create_deck():
	var suit = ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']
	var deck = []
	deck.append_array(suit)
	deck.append_array(suit)
	deck.append_array(suit)
	deck.append_array(suit)
	deck.shuffle()
	return deck
