extends Node2D

# TODO later, have different color chips of different values?
var chip_scene = load("res://chip.tscn")

signal add_button_pressed(id)
signal collect_button_pressed(id)

var offset = Vector2(0, -10)
var chip_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Add chips to the betting area (in number of chips)
func add_chips(amount):
	for i in range(amount):
		var chip = chip_scene.instantiate()
		chip.position = chip_pos
		chip_pos += offset
		# TODO offset the card's position
		$Chips.add_child(chip)

# Clear chips from the betting area and return the amount	
func clear_chips():
	var amount = $Chips.get_child_count()
	for child in $Chips.get_children():
		child.queue_free()
	chip_pos = Vector2.ZERO
	return amount


func _on_add_button_pressed():
	add_button_pressed.emit(get_index())


func _on_collect_button_pressed():
	collect_button_pressed.emit(get_index())

