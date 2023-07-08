extends HitStrategy
@export var naive_limit: int

func should_hit(dealer_card: int, player_cards: Array) -> bool:
	var total: int = HitStrategy.sum(player_cards)
	return total <= naive_limit
