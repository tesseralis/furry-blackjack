extends Node2D

var value = "A"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_value("K")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_value(new_value):
	value = new_value
	$Text.text = value