extends Microgame

const target = preload("res://Scenes/Microgames/MicrogameScripts/Shoot/target.tscn")

@export_group("Level 1")
@export var level_1_max_targets : int = 5
@export var level_1_can_move : bool = false
@export var level_1_max_shots : int = 9999
@export var level_1_target_speeds : Array[float] = [300]

@export_group("Level 2")
@export var level_2_max_targets : int = 100
@export var level_2_can_move : bool = true
@export var level_2_max_shots : int = 9999
@export var level_2_target_speeds : Array[float] = [300, 500]

@export_group("Level 3")
@export var level_3_max_targets : int = 10
@export var level_3_can_move : bool = true
@export var level_3_max_shots : int = 15
@export var level_3_target_speeds : Array[float] = [300, 500, 900]

var max_targets_needed : int = 3
var can_move : bool = false
var max_shots : int = 9999
var target_speeds : Array[float] = []

var target_instances = []
var target_destroyed : int = 0
var shots_taken : int = 0

func apply_difficulty(difficulty : int) -> void:
	if difficulty == LEVEL.EASY:
		max_targets_needed = level_1_max_targets
		can_move = level_1_can_move
		max_shots = level_1_max_shots
		target_speeds = level_1_target_speeds
	elif difficulty == LEVEL.NORMAL:
		max_targets_needed = level_2_max_targets
		can_move = level_2_can_move
		max_shots = level_2_max_shots
		target_speeds = level_2_target_speeds
	elif  difficulty == LEVEL.HARD:
		max_targets_needed = level_3_max_targets
		can_move = level_3_can_move
		max_shots = level_3_max_shots
		target_speeds = level_3_target_speeds
	else:
		print("A mistake has occured in difficulty! Setting to easy")
		max_targets_needed = level_1_max_targets
		can_move = level_1_can_move
		max_shots = level_1_max_shots
		target_speeds = level_1_target_speeds
	pass

func _ready() -> void:
	apply_difficulty(difficulty)
	
	var screen_size = get_viewport().size
	
	for i in range(max_targets_needed):
		var instance = target.instantiate()
		var random_x_pos = randi_range(0, screen_size.x)
		var random_y_pos = randi_range(0, screen_size.y)
		
		instance.position = Vector2(random_x_pos, random_y_pos)
		instance.connect("target_destroyed", _on_target_destroyed)
		target_instances.append(instance)
		
		if can_move:
			var movement_options = ["Vertical", "Horizontal"]
			instance.set_movement(movement_options.pick_random())
			instance.set_speed(target_speeds.pick_random())
			
		add_child(instance)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LMB"):
		shots_taken += 1
		if shots_taken >= max_shots:
			game_finished.emit(PLAYER_LOSE)

func _on_target_destroyed():
	print("target destroyed!")
	target_destroyed += 1
	if target_destroyed >= max_targets_needed:
		game_finished.emit(PLAYER_WIN)
