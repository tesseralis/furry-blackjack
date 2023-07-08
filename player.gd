extends Node2D

@onready var stack = $Stack
@onready var betting_area = $BettingArea
@onready var chat_bubble = $ChatBubble
@export var strategy: HitStrategy

@onready var dealer_card: int = 0

func _ready():
	stack.cards_updated.connect(_on_cards_updated)
	GlobalEvents.hand_start.connect(_on_hand_start)
	GlobalEvents.hand_end.connect(_on_hand_end)
	
func _on_cards_updated(cards: Array):
	if cards.size() < 2:
		chat_bubble.show_text("Deal me in!")
	elif HitStrategy.sum(cards) > 21:
		chat_bubble.show_text("Aw rats!")

	elif dealer_card == 0:
		chat_bubble.show_text("Deal yourself in!")
	else:
		if strategy.should_hit(dealer_card, cards):
			chat_bubble.show_text("Hit me!")
		else:
			if cards.size() == 2 && HitStrategy.sum(cards) == 21:
				chat_bubble.show_text("Blackjack!")
			else:
				chat_bubble.show_text("I'm staying")

func set_dealer_card(value: int):
	dealer_card = value
	_on_cards_updated(stack.get_card_values())

func _on_hand_start():
	chat_bubble.show_text("Deal me in!")
	
func _on_hand_end():
	pass
