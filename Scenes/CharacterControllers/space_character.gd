extends CharacterBody2D

signal landed(landing_speed : float)

@export var SPEED : float = 200
@export var JUMP_VELOCITY : float = -50
@export var gravity_mult : float = 0.6
@export var gravity : float = 1500
@export var peak_height_velocity: float = -700
@export var can_move : bool = false

@onready var velocity_label := $HBoxContainer/Label2

var landing_speed : float = 0.0
var previous_y_velocity: float = 0.0
var was_on_floor : bool = false

func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	was_on_floor = is_on_floor()
	
	if not is_on_floor():
		if velocity.y < peak_height_velocity:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * gravity_mult * delta

	# Handle jump.
	if Input.is_action_pressed("jump"):
		velocity.y += JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("a_key", "d_key")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Check for landing
	if not was_on_floor and is_on_floor():
		landing_speed = abs(previous_y_velocity)
		landed.emit(landing_speed)
	
	if is_on_floor():
		can_move = false
	
	velocity_label.text = str(previous_y_velocity)
	previous_y_velocity = velocity.y

func enable_movement() -> void:
	can_move = true
