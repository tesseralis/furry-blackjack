extends Node2D

@onready var stack = $Stack
@onready var betting_area = $BettingArea
@onready var chat_bubble = $ChatBubble
@onready var player_arm = $AnimatedSprite2D
@export var strategy: HitStrategy
var dealer_hand

@onready var dealer_card: int = 0
var activated = false

func _ready():
	stack.cards_updated.connect(_on_cards_updated)
	GlobalEvents.hand_start.connect(_on_hand_start)
	GlobalEvents.hand_end.connect(_on_hand_end)

func _on_cards_updated(cards: Array):
	if not activated:
		return
	if cards.size() < 2:
		chat_bubble.show_text("Deal me in!")
	elif HitStrategy.sum(cards) > 21:
		chat_bubble.show_text("Aw rats!")

	elif dealer_card == 0:
		chat_bubble.show_text("Deal yourself in!")
	else:
		if strategy.should_hit(dealer_card, cards):
			chat_bubble.show_text("Hit me!")
			player_arm.play("hit")
		else:
			if cards.size() == 2 && HitStrategy.sum(cards) == 21:
				chat_bubble.show_text("Blackjack!")
			else:
				chat_bubble.show_text("I'm staying")
				player_arm.play("stand")

func set_dealer_card(value: int):
	dealer_card = value
	_on_cards_updated(stack.get_card_values())

func activate():
	activated = true
	chat_bubble.visible = true
	stack.visible = true
	betting_area.activate()

func leave():
	activated = false
	chat_bubble.visible = false
	stack.visible = false
	betting_area.deactivate()

func _on_hand_start():
	if activated:
		chat_bubble.show_text("Deal me in!")
	
func _on_hand_end():
	var player_value = HitStrategy.sum(stack.get_card_values())
	var dealer_value = HitStrategy.sum(dealer_hand.get_card_values())
	# TODO take chips if won
	if player_value <= 21:
		if dealer_value > 21 or player_value > dealer_value:
			chat_bubble.show_text("I won!")
		elif dealer_value > player_value:
			chat_bubble.show_text("Rats...")
		else:
			chat_bubble.show_text("It's a draw...")
