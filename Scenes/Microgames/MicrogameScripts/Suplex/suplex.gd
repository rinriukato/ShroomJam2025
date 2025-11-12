extends Microgame

enum key_inputs {LEFT, RIGHT, UP, DOWN}

const valid_rotations = [
	[key_inputs.UP, key_inputs.RIGHT, key_inputs.DOWN, key_inputs.LEFT],
	[key_inputs.RIGHT, key_inputs.DOWN, key_inputs.LEFT, key_inputs.UP],
	[key_inputs.DOWN, key_inputs.LEFT,key_inputs.UP, key_inputs.RIGHT],
	[key_inputs.LEFT, key_inputs.UP, key_inputs.RIGHT, key_inputs.DOWN]
]

@export var num_rotations_needed : int = 3
@export var num_upward_motion_needed : int = 1
@export var min_upward_vector : float = -20.0

@onready var attack_rating_label := $CanvasLayer/UI/VBoxContainer/AttackRatingLabel
@onready var num_rotations_needed_label := $CanvasLayer/Control/HBoxContainer/NumRotationsNeeded
@onready var upward_motion_timer := $UpwardMotionTimer
@onready var input_display := $InputDisplay

var input_buffer : Array[key_inputs] = []
var current_rotations : int = 0
var current_upward_motions : int = 0
var check_for_finisher : bool = false # Flag for checking for upward motion for 'finisher'
var can_upward_motion : bool = true # Flag for upward motion cooldown

func _process(delta: float) -> void:
	# Stop processing key inputs when looking for finisher
	if check_for_finisher:
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
	
func _input(event: InputEvent) -> void:
	if not check_for_finisher:
		return
	
	if event is InputEventMouseMotion:
		print(event.relative)
		
		# An "upward mouse motion" is indicated by the y vector being negative,
		# We generally want a fast upward motion, so non -1 vector
		if can_upward_motion and event.relative.y <= min_upward_vector:
			current_upward_motions += 1
			can_upward_motion = false
			upward_motion_timer.start()
			
			## NOTE: You need to prompt the user to keep doing these motions
			if current_upward_motions >= num_upward_motion_needed:
				game_finished.emit(PLAYER_WIN)


func _check_action() -> void:
	if _check_valid_clockwise_rotation():
		print("Valid rotation!")
		current_rotations += 1
		_update_text()
		if current_rotations >= num_rotations_needed:
			check_for_finisher = true
		
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
	num_rotations_needed_label.text = str(num_rotations_needed - current_rotations)
	attack_rating_label.text = _get_attack_label_text()

## TODO: Replace this with actual mario and luigi attack ratings and sfx
func _get_attack_label_text() -> String:
	if current_rotations == num_rotations_needed:
		return "EXCELLENT"
	elif current_rotations >= floor(num_rotations_needed/2):
		return "GREAT"
	else:
		return "GOOD"

func _on_upward_motion_timer_timeout() -> void:
	can_upward_motion = true
