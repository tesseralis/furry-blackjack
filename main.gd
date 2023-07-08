extends Node2D

var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	players = [$PlayerStack1, $PlayerStack2, $PlayerStack3, $PlayerStack4]
	for i in range(players.size()):
		players[i].id = i
		players[i].deal_button_pressed.connect(_on_deal_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_deal_button_pressed(id):
	var card_value = $Deck.take_card()
	players[id].add_card(card_value)

