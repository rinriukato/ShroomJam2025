extends Microgame

enum key_inputs {LEFT, RIGHT, UP, DOWN}

const valid_rotations = [
	[key_inputs.UP, key_inputs.RIGHT, key_inputs.DOWN, key_inputs.LEFT],
	[key_inputs.RIGHT, key_inputs.DOWN, key_inputs.LEFT, key_inputs.UP],
	[key_inputs.DOWN, key_inputs.LEFT,key_inputs.UP, key_inputs.RIGHT],
	[key_inputs.LEFT, key_inputs.UP, key_inputs.RIGHT, key_inputs.DOWN]
]
@export_group("Level 1")
@export var level_1_rotations_needed : int = 3

@export_group("Level 2")
@export var level_2_rotations_needed : int = 7

@export_group("Level 3")
@export var level_3_rotations_needed : int = 15

@export var min_upward_vector : float = -20.0

@onready var attack_rating_label := $CanvasLayer/UI/VBoxContainer/AttackRatingLabel
@onready var num_rotations_needed_label := $CanvasLayer/Control/HBoxContainer/NumRotationsNeeded
@onready var input_display := $InputDisplay
@onready var anim_player := $Sprite2D/AnimationPlayer
@onready var ok_sound := $OkSound
@onready var good_sound := $GoodSound
@onready var great_sound := $GreatSound
@onready var excellent_sound := $ExcellentSound

var num_rotations_needed : int = 3
var input_buffer : Array[key_inputs] = []
var current_rotations : int = 0
var current_upward_motions : int = 0
var check_for_input : bool = true

func apply_difficulty(difficulty : int) -> void:
	if difficulty == LEVEL.EASY:
		num_rotations_needed = level_1_rotations_needed
	elif difficulty == LEVEL.NORMAL:
		num_rotations_needed = level_2_rotations_needed
	elif  difficulty == LEVEL.HARD:
		num_rotations_needed = level_3_rotations_needed
	else:
		print("A mistake has occured in difficulty! Setting to easy")
		num_rotations_needed = level_1_rotations_needed

func _ready() -> void:
	apply_difficulty(difficulty)
	_update_text()
	anim_player.play("charging")

func _process(delta: float) -> void:
	if not check_for_input:
		input_buffer.clear()
		input_display.clear_inputs()
		return
	
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
		_check_action()

func _check_action() -> void:
	if _check_valid_clockwise_rotation():
		print("Valid rotation!")
		attack_rating_label.text = _get_attack_label_text()
		current_rotations += 1
		_update_text()
		if current_rotations >= num_rotations_needed:
			anim_player.play("finisher")
			check_for_input = false
		
		input_buffer.clear()
		input_display.clear_inputs()
		
	else:
		print("Not valid rotation")
	pass

## This function checks for a valid rotation:
## A valid "rotation" is simply the following sequences:
## W -> D -> S -> A
## D -> S -> A -> W
## S -> A -> W -> D
## A -> W -> D -> S
## For lienecy, we only want to clear the buffer if and only if they make a successful rotation
func _check_valid_clockwise_rotation() -> bool:
	if input_buffer.size() < 3:
		return false
	
	if input_buffer in valid_rotations:
		return true
	else:
		return false
	
func _update_text() -> void:
	num_rotations_needed_label.text = str(current_rotations) + " / " + str(num_rotations_needed)

## TODO: Replace this with actual mario and luigi attack ratings and sfx
func _get_attack_label_text() -> String:
	if current_rotations >= floor(num_rotations_needed/2):
		great_sound.play()
		return "Great"
	elif current_rotations >= floor(num_rotations_needed/3):
		good_sound.play()
		return "Good"
	else:
		ok_sound.play()
		return "Okay"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "finisher":
		game_finished.emit(PLAYER_WIN)
