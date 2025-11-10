extends CharacterBody2D

signal hit_player

enum Direction {LEFT = -1, RIGHT = 1}

@export var speed = 1000.0
@export var can_go : bool = false
@export var car_direction: Direction = Direction.LEFT

func _physics_process(delta: float) -> void:
	if not can_go: return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	var dir_value = car_direction
	
	if dir_value:
		velocity.x = dir_value * speed

	move_and_slide()

func enable_car() -> void:
	can_go = true


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit_player.emit()
		print("hit player!")
