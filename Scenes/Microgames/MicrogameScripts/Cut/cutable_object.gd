extends RigidBody2D

signal cut_complete
signal successful_cut
signal object_missed

@export var impulse_force : float = 500
@export var torque_impulse : float = 500
@export var min_spawn_launch_force : float = 800
@export var max_spawn_launch_force : float = 900
@export var min_x_angle : float = -0.2
@export var max_x_angle : float = 0.2

var left_half = preload("res://Scenes/Microgames/MicrogameScripts/Cut/left_half.tscn")
var right_half = preload("res://Scenes/Microgames/MicrogameScripts/Cut/right_half.tscn")

var entry_mouse_pos : Vector2
var exit_mouse_pos : Vector2
var min_cut_angle : float = 0.65

func _ready() -> void:
	var spawn_launch_force = randi_range(min_spawn_launch_force, max_spawn_launch_force)
	var entry_vector = Vector2(randf_range(min_x_angle, max_x_angle), -1.0)
	apply_impulse(entry_vector * spawn_launch_force)

func _on_hit_box_mouse_entered() -> void:
	entry_mouse_pos = get_global_mouse_position()	

func _on_hit_box_mouse_exited() -> void:
	exit_mouse_pos = get_global_mouse_position()
	cut_complete.emit()

func _on_cut_complete() -> void:
	var cut_direction = entry_mouse_pos.direction_to(exit_mouse_pos)
	_check_cut(cut_direction)

func _check_cut(cut_direction: Vector2) -> void:
	if abs(cut_direction.y) >= min_cut_angle:
		successful_cut.emit()
		slice_object(cut_direction.y)

func slice_object(slice_angle) -> void:
	var l_half = left_half.instantiate()
	var r_half = right_half.instantiate()

	get_parent().add_child(l_half)
	get_parent().add_child(r_half)
	
	l_half.global_position = global_position
	r_half.global_position = global_position
	
	var force = Vector2.RIGHT.rotated(slice_angle) * 200
	l_half.position += force.rotated(-PI/4)
	r_half.position += force.rotated(PI/4)
	
	var dir = Vector2.RIGHT.rotated(slice_angle)
	
	l_half.apply_impulse(-dir * impulse_force)
	r_half.apply_impulse(dir * impulse_force)
	
	l_half.apply_torque_impulse(-torque_impulse)
	r_half.rotate(torque_impulse)
	
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	object_missed.emit()
	print("Object Missed")
	queue_free()
