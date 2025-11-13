extends Microgame

enum key_inputs {LEFT, RIGHT, UP, DOWN}

var max_correct : int = 3
var max_incorrects : int = 3

@export_group("Level 1")
@export var level_1_max_correct : int = 3
@export var level_1_max_incorrects : int = 3

@export_group("Level 2")
@export var level_2_max_correct : int = 7
@export var level_2_max_incorrects : int = 1

@export_group("Level 3")
@export var level_3_max_correct : int = 10
@export var level_3_max_incorrects : int = 0

@onready var item_1_icon := $YesNoItem
@onready var item_2_icon := $YesNoItem2
@onready var input_display := $InputDisplay
@onready var correct_incorrect := $CorrectIncorrect
@onready var points_needed_label := $VBoxContainer/HBoxContainer/Points
@onready var mistakes_label := $VBoxContainer/HBoxContainer2/Mistakes

var input_buffer : Array[key_inputs] = []
var current_wins : int = 0
var current_incorrects : int = 0
var item_1_val : int
var item_2_val : int
var num_items = 3

func apply_difficulty(difficulty : int) -> void:
	if difficulty == LEVEL.EASY:
		max_correct = level_1_max_correct
		max_incorrects = level_1_max_incorrects
	elif difficulty == LEVEL.NORMAL:
		max_correct = level_2_max_correct
		max_incorrects = level_2_max_incorrects
	elif  difficulty == LEVEL.HARD:
		max_correct = level_3_max_correct
		max_incorrects = level_3_max_incorrects
	else:
		print("A mistake has occured in difficulty! Setting to easy")
		max_correct = level_1_max_correct
		max_incorrects = level_3_max_incorrects

func _ready() -> void:
	apply_difficulty(difficulty)
	_update_labels()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("a_key"):
		input_buffer.append(key_inputs.LEFT)
	if Input.is_action_just_pressed("d_key"):
		input_buffer.append(key_inputs.RIGHT)
	if Input.is_action_just_pressed("w_key"):
		input_buffer.append(key_inputs.UP)
	if Input.is_action_just_pressed("s_key"):
		input_buffer.append(key_inputs.DOWN)
	
	if input_buffer.size() >= 4:
		input_buffer = input_buffer.slice(-4)
		_check_action_and_reset()
	
func _check_action_and_reset() -> void:
	
	if _is_yes_oscillation():
		print("Valid Yes!")
		_check_objects_matching(true)
		_reset_round()
	elif _is_no_oscillation():
		print("Valid No!")
		_check_objects_matching(false)
		_reset_round()
	else:
		print("invalid combination")

func _is_no_oscillation() -> bool:
	if input_buffer.size() < 3:
		return false
	
	for i in range(1, input_buffer.size()):
		var a = input_buffer[i - 1]
		var b = input_buffer[i]
		if not ((a == key_inputs.LEFT and b == key_inputs.RIGHT) || (a == key_inputs.RIGHT and b == key_inputs.LEFT)):
			return false
	return true
	
func _is_yes_oscillation() -> bool:
	for i in range(1, input_buffer.size()):
		var a = input_buffer[i - 1]
		var b = input_buffer[i]
		if not ((a == key_inputs.UP and b == key_inputs.DOWN) || (a == key_inputs.DOWN and b == key_inputs.UP)):
			return false			
	return true


func _reset_round() -> void:
	_update_labels()
	input_buffer.clear()
	input_display.clear_inputs()
	var random = randi() % num_items
	item_1_val = random
	item_1_icon.change_appearance(random)
	
	random = randi() % num_items
	item_2_val = random
	item_2_icon.change_appearance(random)
	
	# Probably do some image swapping, and animations here....
	
func _check_objects_matching(respond_yes) -> void:
	var is_object_matching = (item_1_val == item_2_val)
	
	if respond_yes and is_object_matching:
		print("Correct! They did match!")
		correct_incorrect.correct()
		current_wins += 1
	elif respond_yes and not is_object_matching:
		print("Incorrect! Objects did match!")
		correct_incorrect.incorrect()
		current_incorrects += 1
	elif not respond_yes and not is_object_matching:
		print("Correct! They did not match!")
		correct_incorrect.correct()
		current_wins += 1
	else:
		correct_incorrect.incorrect()
		print("Incorrect, the objects matched...")
		current_incorrects += 1
	
	if current_wins >= max_correct:
		game_finished.emit(PLAYER_WIN)
	if current_incorrects >= max_incorrects:
		game_finished.emit(PLAYER_LOSE)

func _update_labels() -> void:
	points_needed_label.text = str(current_wins) + " / " + str(max_correct)
	mistakes_label.text = str(current_incorrects) + " / " + str(max_incorrects)
