extends CharacterBody2D

signal hit_player

enum Direction {LEFT = -1, RIGHT = 1}

@export var speed : float = 1000.0 : set = set_speed
@export var jump_power : float  = -1000.0
@export var gravity_mult: float = 3.2
@export var can_go : bool = false
@export var car_direction: Direction = Direction.LEFT
@export var can_jump : bool : set = set_can_jump


func _physics_process(delta: float) -> void:
	if not can_go: return
	
	if not is_on_floor():
		velocity += get_gravity() * gravity_mult * delta
	
	
	var dir_value = car_direction
	
	if dir_value:
		velocity.x = dir_value * speed

	move_and_slide()

func enable_car() -> void:
	can_go = true

func jump() -> void:
	if can_jump:
		velocity.y = jump_power
		move_and_slide()
	
func set_speed(new_speed: float) -> void:
	if new_speed == speed:
		return
	speed = new_speed
	
func set_can_jump(new_value: bool) -> void:
	if can_jump == new_value:
		return
	can_jump = new_value

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit_player.emit()
		print("hit player!")
