extends Node2D
class_name Card

@onready var value: String
@onready var facedown = $facedown

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_value(new_value: String):
	value = new_value
	$Text.text = str(value)

func get_int_value() -> int:
	if value == "A":
		return 1
	elif value == "K" or value == "Q" or value == "J":
		return 10
	else:
		return int(value)

func set_facedown(is_facedown: bool):
	if is_facedown:
		facedown.visible = true
	else:
		facedown.visible = false
		
func get_facedown() -> bool:
	return facedown.visible == true
