extends Node

signal game_finished

var is_food1_okay : bool = false
var is_food2_okay : bool = false
var max_rounds : int = 3
var current_round = 0

@onready var food1_label_left := $CanvasLayer/UI/HBoxContainer/Food1
@onready var food2_label_right := $CanvasLayer/UI/HBoxContainer/Food2


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("a_key"):
		if is_food1_okay:
			print("You got a point!")
		else:
			print("You ate a bomb...")
	if event.is_action_pressed("d_key"):
		if is_food2_okay:
			print("You got a point!")
		else:
			print("You ate a bomb...")
	_restart_round()
	

func _restart_round() -> void:
	current_round += 1
	
	if current_round >= max_rounds:
		emit_signal("game_finished")
		return;
	else:
		_set_food_values()
		_set_food_text(food1_label_left, is_food1_okay)
		_set_food_text(food2_label_right, is_food2_okay)

## Food1 is always randomize, food 2 is always the opposite
func _set_food_values() -> void:
	is_food1_okay = _randomize_bool()
	is_food2_okay = !is_food1_okay
	
## Temp function, but to showcase which food is what
func _set_food_text(label: Label, is_food : bool) -> void:
	if is_food:
		label.text = "FOOD"
	else:
		label.text = "BOMB"

func _randomize_bool() -> bool:
	return randi() % 2 == 0
