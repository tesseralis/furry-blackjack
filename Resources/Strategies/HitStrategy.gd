extends Resource
class_name HitStrategy

func should_hit(dealer_card: int, player_cards: Array) -> bool:
	return true

static func sum(player_cards: Array) -> int:
	var aces_count := 0
	var card_sum := 0
	for card in player_cards:
		if card == 1:
			aces_count += 1
			card_sum += 10
		card_sum += card
		
	while card_sum > 21 and aces_count > 0:
		card_sum -= 10
		aces_count -= 1
		
	return card_sum
