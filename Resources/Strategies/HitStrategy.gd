extends Resource
class_name HitStrategy

func should_hit(dealer_card: int, player_cards: Array[int]) -> bool:
	return true

func sum(player_cards: Array[int]) -> int:
	var aces_count := 0
	var sum := 0
	for card in player_cards:
		if card == 1:
			aces_count += 1
			sum += 10
		sum += card
		
	while sum > 21 and aces_count > 0:
		sum -= 10
		aces_count -= 1
		
	return sum
