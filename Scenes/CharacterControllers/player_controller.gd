extends CharacterBody2D


@export var SPEED : float = 450.0
@export var JUMP_VELOCITY : float= -800
@export var gravity_mult : float = 1.7
@export var gravity : float = 2000
@export var peak_height_velocity: float = -700

@onready var jump_buffer_timer := $JumpBuffer

var jump_buffer : bool = false

func _physics_process(delta: float) -> void:
	buffer_jump()
	
	if not is_on_floor():
		if velocity.y < peak_height_velocity:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * gravity_mult * delta

	# Handle jump.
	if (Input.is_action_just_pressed("jump") or jump_buffer) and is_on_floor():
		jump_buffer = false
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("a_key", "d_key")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func buffer_jump() -> void:
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		jump_buffer = true
		jump_buffer_timer.start()


func _on_jump_buffer_timeout() -> void:
	jump_buffer = false
