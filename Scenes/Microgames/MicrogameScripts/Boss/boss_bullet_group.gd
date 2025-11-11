extends CharacterBody2D

@export var bullet_speed: float = 200.0
@export var rotation_speed : float = 60.0

@onready var center := $Center

func _process(delta: float) -> void:
	_rotate_bullet_group(delta)
	
	var forward = Vector2.RIGHT.rotated(rotation)
	
	velocity = forward * bullet_speed
	move_and_slide()



func _rotate_bullet_group(delta: float) -> void:
	center.rotate(deg_to_rad(rotation_speed) * delta)

func _on_expire_timer_timeout() -> void:
	queue_free()
