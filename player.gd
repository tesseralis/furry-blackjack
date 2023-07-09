extends Node2D

@onready var stack = $Stack
@onready var betting_area = $BettingArea
@onready var chat_bubble = $ChatBubble
@onready var player_arm = $PlayerArm
@export var strategy: HitStrategy
var dealer_hand

@onready var dealer_card: int = 0
var chips: int = 0
var activated = false
var current_bet = 0
var awaiting_payout = false
var anger = 0
var expect_deal = false

signal player_left(complaint)

func _ready():
	stack.cards_updated.connect(_on_cards_updated)
	GlobalEvents.hand_start.connect(_on_hand_start)
	GlobalEvents.hand_end.connect(_on_hand_end)
	GlobalEvents.rule_broken.connect(_on_rule_broken)

func _on_cards_updated(cards: Array):
	if not activated:
		return
	if current_bet == 0 or awaiting_payout:
		return
	if cards.size() > 2 and not expect_deal:
		chat_bubble.show_text("I didn't ask for this!")
		GlobalEvents.rule_broken.emit()
		return
	if cards.size() < 2:
		chat_bubble.show_text("Deal me in!")
		expect_deal = true
	elif HitStrategy.sum(cards) > 21:
		chat_bubble.show_text("Aw rats!")
		expect_deal = false

	elif dealer_card == 0:
		chat_bubble.show_text("Deal yourself in!")
	else:
		if strategy.should_hit(dealer_card, cards):
			chat_bubble.show_text("Hit me!")
			player_arm.play("hit")
			expect_deal = true
		else:
			expect_deal = false
			if cards.size() == 2 && HitStrategy.sum(cards) == 21:
				chat_bubble.show_text("Blackjack!")
			else:
				chat_bubble.show_text("I'm staying")
				player_arm.play("stand")



func set_dealer_card(value: int):
	var old_value = dealer_card
	dealer_card = value
	if old_value == 0:
		_on_cards_updated(stack.get_card_values())

func activate():
	activated = true
	chat_bubble.visible = true
	stack.visible = true
	player_arm.visible = true
	betting_area.activate()

func leave(msg = "I'm outta here...", complaint = false):
	chat_bubble.show_text(msg)
	await get_tree().create_timer(2.0).timeout
	activated = false
	chat_bubble.visible = false
	stack.visible = false
	player_arm.visible = false
	player_left.emit(complaint)
	betting_area.deactivate()

func increment_anger(amount = 1):
	anger += amount
	if anger >= 3:
		leave("I'm calling the manager!", true)

func collect_chips():
	chips += betting_area.clear_chips()
	
func clear_chips()-> int:
	current_bet = 0 
	return betting_area.clear_chips()

func _on_hand_start():
	collect_chips()
	if awaiting_payout:
		awaiting_payout = false
		GlobalEvents.rule_broken.emit()
	if activated:
		chat_bubble.show_text("Deal me in!")
		expect_deal = true
		current_bet = min(range(1, 4).pick_random(), chips)
		betting_area.add_chips(current_bet)
		chips -= current_bet
	
func _on_hand_end():
	if !activated or current_bet == 0:
		return
	var player_value = HitStrategy.sum(stack.get_card_values())
	var dealer_value = HitStrategy.sum(dealer_hand.get_card_values())
	if expect_deal:
		chat_bubble.show_text("I wanted a card.")
		GlobalEvents.rule_broken.emit()

	if player_value <= 21:
		if dealer_value > 21 or player_value > dealer_value:
			chat_bubble.show_text("I won!")
			awaiting_payout = true
		elif dealer_value > player_value:
			chat_bubble.show_text("Rats...")
		else:
			chat_bubble.show_text("It's a draw...")
			collect_chips()
	expect_deal = false
	if chips <= 0:
		leave("Ran out of money...")
	if chips > 20:
		leave("That's enough winning for me!")

func _on_betting_area_add_button_pressed():
	if not awaiting_payout:
		chat_bubble.show_text("Oh thank you!")
	elif awaiting_payout and betting_area.get_amount() >= 2 * current_bet:
		collect_chips()
		awaiting_payout = false

func _on_rule_broken():
	chat_bubble.show_text("What's the big idea?")
	increment_anger()
