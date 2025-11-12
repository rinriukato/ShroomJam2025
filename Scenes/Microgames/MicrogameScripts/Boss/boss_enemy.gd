extends CharacterBody2D

signal boss_death

enum LEVEL {EASY, NORMAL, HARD}

# =================== Default Boss Settings ===================
@export var speed : float = 0.2
@export var move_range : float = 500.0
@export var max_health : int = 100
@export var shot_wave_time : float = 3.0

@export_category("Spread Shot")
@export var bullet_fan_count : int = 6
@export var spread_angle_deg : float = 60
@export var spread_shot_waves : int = 5
@export var spread_shot_interval : float = 0.2

@export_category("Group Shot")
@export var group_shot_waves : int = 3
@export var group_shot_interval : float = 1.5

@export_category("Laser")
@export var laser_duration : float = 3.0

# =================== Difficulty Config ======================
@export_group("Level 1 - Default")
@export var level_1_max_health : int = 100
@export var level_1_bullet_fan_count : int = 6
@export var level_1_spread_angle_deg : float = 60
@export var level_1_spread_shot_waves : int = 5
@export var level_1_spread_shot_interval : float = 0.2
@export var level_1_group_shot_waves : int = 3
@export var level_1_group_shot_interval : float = 1.5
@export var level_1_laser_duration : float = 3.0
@export var level_1_shot_wave_time : float = 3.0

@export_group("Level 2 - Buffed Health & Shots")
@export var level_2_max_health : int = 150
@export var level_2_bullet_fan_count : int = 8
@export var level_2_spread_angle_deg : float = 60
@export var level_2_spread_shot_waves : int = 6
@export var level_2_spread_shot_interval : float = 0.2
@export var level_2_group_shot_waves : int = 4
@export var level_2_group_shot_interval : float = 1.5
@export var level_2_laser_duration : float = 3.0
@export var level_2_shot_wave_time : float = 3.0

@export_group("Level 3 - Buffed + Faster Fire")
@export var level_3_max_health : int = 150
@export var level_3_bullet_fan_count : int = 8
@export var level_3_spread_angle_deg : float = 60
@export var level_3_spread_shot_waves : int = 6
@export var level_3_spread_shot_interval : float = 0.1
@export var level_3_group_shot_waves : int = 4
@export var level_3_group_shot_interval : float = 1.0
@export var level_3_laser_duration : float = 3.0
@export var level_3_shot_wave_time : float = 2.0


# =================== References =============================
@onready var sprite := $Sprite2D
@onready var shot_wave_timer := $ShotWaveTimer
@onready var laser := $LaserBeam

var bullet_prefab := preload("res://Scenes/Microgames/MicrogameScripts/Boss/boss_bullet.tscn")
var bullet_group_prefab := preload("res://Scenes/Microgames/MicrogameScripts/Boss/boss_bullet_group.tscn")
var health : int 
var start_position : Vector2
var player


func _ready() -> void:
	randomize()
	start_position = global_position
	player = get_parent().find_child("BulletHellCharacter")
	if player != null:
		print("Found player!")

	
	var diff = get_parent().difficulty
	_apply_difficulty(diff)

	# Set timers and health
	shot_wave_timer.wait_time = shot_wave_time
	health = max_health


# =================== Apply Difficulty ======================
func _apply_difficulty(difficulty : int) -> void:
	if difficulty == 0:
		max_health = level_1_max_health
		bullet_fan_count = level_1_bullet_fan_count
		spread_angle_deg = level_1_spread_angle_deg
		spread_shot_waves = level_1_spread_shot_waves
		spread_shot_interval = level_1_spread_shot_interval
		group_shot_waves = level_1_group_shot_waves
		group_shot_interval = level_1_group_shot_interval
		laser_duration = level_1_laser_duration
		shot_wave_time = level_1_shot_wave_time

	elif difficulty == LEVEL.NORMAL:
		max_health = level_2_max_health
		bullet_fan_count = level_2_bullet_fan_count
		spread_angle_deg = level_2_spread_angle_deg
		spread_shot_waves = level_2_spread_shot_waves
		spread_shot_interval = level_2_spread_shot_interval
		group_shot_waves = level_2_group_shot_waves
		group_shot_interval = level_2_group_shot_interval
		laser_duration = level_2_laser_duration
		shot_wave_time = level_2_shot_wave_time

	elif difficulty == LEVEL.HARD:
		max_health = level_3_max_health
		bullet_fan_count = level_3_bullet_fan_count
		spread_angle_deg = level_3_spread_angle_deg
		spread_shot_waves = level_3_spread_shot_waves
		spread_shot_interval = level_3_spread_shot_interval
		group_shot_waves = level_3_group_shot_waves
		group_shot_interval = level_3_group_shot_interval
		laser_duration = level_3_laser_duration
		shot_wave_time = level_3_shot_wave_time

	else:
		push_warning("Unknown difficulty! Defaulting to EASY.")
		_apply_difficulty(LEVEL.EASY)


func _physics_process(delta: float) -> void:
	var x_offset = sin(Time.get_ticks_msec() / 1000.0 * speed) * move_range
	global_position.x = start_position.x + x_offset


func _shoot_bullet_fan() -> void:
	var start_angle = -deg_to_rad(spread_angle_deg / 2)
	var angle_step = deg_to_rad(spread_angle_deg / (bullet_fan_count - 1))
	
	for j in range(spread_shot_waves):
		for i in range(bullet_fan_count):
			var bullet = bullet_prefab.instantiate()
			get_parent().add_child(bullet)
			bullet.global_position = global_position
			
			if player != null:
				bullet.look_at(player.global_position)
			
			bullet.rotation += (start_angle + angle_step * i)
		
		await get_tree().create_timer(spread_shot_interval).timeout
	
	shot_wave_timer.start()


func _shoot_group_shot() -> void:
	for i in range(group_shot_waves):
		var bullet_group = bullet_group_prefab.instantiate()
		get_parent().add_child(bullet_group)
		bullet_group.global_position = global_position
		
		if player != null:
			bullet_group.look_at(player.global_position)
		
		await get_tree().create_timer(group_shot_interval).timeout
	
	shot_wave_timer.start()


func _shoot_laser() -> void:
	laser.set_is_casting(true)
	await get_tree().create_timer(laser_duration).timeout
	laser.set_is_casting(false)


func take_damage(damage: int) -> void:
	print(health)
	health -= damage
	if health < 0:
		print("I DIED")
		boss_death.emit()
		queue_free()


func _on_shot_wave_timer_timeout() -> void:
	var shot_type = randi_range(0, 2)
	if shot_type == 0:
		_shoot_bullet_fan()
	elif shot_type == 1:
		_shoot_group_shot()
	else:
		_shoot_laser()
