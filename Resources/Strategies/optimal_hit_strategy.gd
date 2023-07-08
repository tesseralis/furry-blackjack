extends HitStrategy

func should_hit(dealer_card: int, cards: Array) -> bool:
	var soft_total := soft_sum(cards)
	var hard_total := HitStrategy.sum(cards)
	if soft_total != hard_total:
		if(soft_total <= 7):
			return true
		if(soft_total == 18 && (dealer_card == 9 || dealer_card == 10)):
			return true
		return false
	if hard_total <= 11:
		return true
	if hard_total == 12 && !(dealer_card == 4 || dealer_card == 5 || dealer_card == 6):
		return true
	if (hard_total >= 13 && hard_total <= 16) && (dealer_card >= 7):
		return true
	return false


static func soft_sum(player_cards: Array) -> int:
	var card_sum := 0
	for card in player_cards:
		card_sum += card
		
	return card_sum
