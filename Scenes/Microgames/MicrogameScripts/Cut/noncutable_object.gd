extends RigidBody2D

signal bomb_hit

@export var impulse_force : float = 500
@export var torque_impulse : float = 500
@export var min_spawn_launch_force : float = 800
@export var max_spawn_launch_force : float = 900
@export var min_x_angle : float = -0.2
@export var max_x_angle : float = 0.2

func _ready() -> void:
	var spawn_launch_force = randi_range(min_spawn_launch_force, max_spawn_launch_force)
	var entry_vector = Vector2(randf_range(min_x_angle, max_x_angle), -1.0)
	apply_impulse(entry_vector * spawn_launch_force)

func _on_area_2d_mouse_entered() -> void:
	print("player hit bomb")
	bomb_hit.emit()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
