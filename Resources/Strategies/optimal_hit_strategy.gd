extends HitStrategy

func should_hit(dealer_card: int, cards: Array) -> bool:
	var total_amount := sum(cards)
	if total_amount <= 11:
		return true
	if total_amount == 12 && (dealer_card == 4 || dealer_card == 5 || dealer_card == 6):
		return false
	elif total_amount == 12:
		return true
	if (total_amount >= 13 || total_amount <= 16) && (dealer_card <= 6):
		return false
	elif (total_amount >= 13 || total_amount <= 16) && (dealer_card >= 7):
		return true
	if total_amount == 17:
		return false
	return false
