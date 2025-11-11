@tool
extends RayCast2D

@export var cast_speed : float = 7000.0
@export var max_length : float = 1400.0
@export var start_distance : float = 40.0
@export var is_casting := false: set = set_is_casting
@export var color := Color.WHITE: set = set_color
@export var growth_time := 0.1

var tween: Tween = null

@onready var line_2d : Line2D = $Line2D
@onready var line_width := line_2d.width
@onready var casting_particles := $CastingParticles
@onready var beam_particles := $BeamParticles

func _ready() -> void:
	set_color(color)
	set_is_casting(is_casting)
	line_2d.points[0] = Vector2.DOWN * start_distance
	line_2d.points[1] = Vector2.ZERO
	line_2d.visible = false
	casting_particles.position = line_2d.points[0]

func _physics_process(delta: float) -> void:
	target_position.y = move_toward(
		target_position.y, 
		max_length,
		cast_speed * delta
	)
	
	var laser_end_position := target_position
	line_2d.points[1] = laser_end_position
	
	var laser_start_position := line_2d.points[0]
	beam_particles.position = laser_start_position + (laser_end_position - laser_start_position) * 0.5
	beam_particles.process_material.emission_box_extents.x = laser_end_position.distance_to(laser_start_position) * 0.5
	
	
	if is_colliding and is_casting:
		var collider = get_collider()
		
		if collider is Area2D and collider.is_in_group("player_hitbox"):
			var player = collider.get_parent()
			if player.has_method("take_damage"):
				player.take_damage(1)

	
func set_is_casting(new_value : bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value
	
	set_physics_process(is_casting)
	
	if beam_particles == null:
		return
		
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting
	
	if not line_2d:
		return
	
	if is_casting:
		var laser_start := Vector2.DOWN * start_distance
		line_2d.points[0] = laser_start
		line_2d.points[1] = laser_start
		appear()
	else:
		target_position = Vector2.ZERO
		disappear()

	

func set_color(new_color: Color) -> void:
	color = new_color
	if line_2d == null:
		return
	line_2d.modulate = new_color
	casting_particles.modulate = new_color
	beam_particles.modulate = new_color

func appear() -> void:
	line_2d.visible = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", line_width, growth_time * 2.0).from(0.0)

func disappear() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", 0.0, growth_time).from_current()
	tween.tween_callback(line_2d.hide)
