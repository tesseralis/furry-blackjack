extends Node2D

@onready var anger_bar = $TextureProgressBar
@onready var animation_player = $AnimationPlayer


func set_anger(anger: int, max_anger: int):
	anger_bar.max_value = max_anger
	anger_bar.value = anger
	animation_player.play("bump")
