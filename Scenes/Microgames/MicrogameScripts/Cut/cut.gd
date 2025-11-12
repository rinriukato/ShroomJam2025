extends Microgame

@export var delay_between_objects : float = 0.7

@onready var spawn_points := $SpawnPoints
@onready var start_timer := $StartTimer
@onready var cuts_needed_label := $CanvasLayer/Control/HBoxContainer/Label2

@export_group("Level 1")
@export var level_1_min_cuts_needed : int = 3
@export var level_1_max_objects : int = 5
@export var level_1_num_bombs : int = 0

@export_group("Level 2")
@export var level_2_min_cuts_needed : int = 5
@export var level_2_max_objects : int = 7
@export var level_2_num_bombs : int = 0

@export_group("Level 3")
@export var level_3_min_cuts_needed : int = 10
@export var level_3_max_objects : int = 10
@export var level_3_num_bombs : int = 4

var cutable_object = preload("res://Scenes/Microgames/MicrogameScripts/Cut/cutable_object.tscn")
var noncutable_object = preload("res://Scenes/Microgames/MicrogameScripts/Cut/noncutable_object.tscn")
var spawn_positions : Array[Vector2]
var num_successful_cut : int = 0
var num_misses : int = 0
var objects_spawned : int = 0
var bombs_spawned : int = 0

var cuts_needed : int = 3
var max_objects : int = 5
var num_bombs : int = 0

func apply_difficulty(difficulty : int) -> void:
	if difficulty == LEVEL.EASY:
		cuts_needed = level_1_min_cuts_needed
		max_objects = level_1_max_objects
		num_bombs = level_1_num_bombs
	elif difficulty == LEVEL.NORMAL:
		cuts_needed = level_2_min_cuts_needed
		max_objects = level_2_max_objects
		num_bombs = level_2_num_bombs
	elif  difficulty == LEVEL.HARD:
		cuts_needed = level_3_min_cuts_needed
		max_objects = level_3_max_objects
		num_bombs = level_3_num_bombs
	else:
		print("A mistake has occured in difficulty! Setting to easy")
		cuts_needed = level_1_min_cuts_needed
		max_objects = level_1_max_objects
		num_bombs = level_1_num_bombs

func _ready() -> void:
	apply_difficulty(difficulty)
	_get_spawn_positions()

func _get_spawn_positions() -> void:
	for node : Node2D in spawn_points.get_children():
		spawn_positions.append(node.global_position)

func _spawn_objects() -> void:
	var spawn_types  = []
	
	for i in range(max_objects):
		spawn_types.append("cutable")
	for i in range(num_bombs):
		spawn_types.append("bomb")
	spawn_types.shuffle()
	
	var positions = spawn_positions.duplicate()
	
	for i in range(max_objects + num_bombs):
		if positions.is_empty():
			positions = spawn_positions.duplicate()
		
		positions.shuffle()
		var spawn_pos = positions.pop_back()
		var object_to_spawn = spawn_types[i]
		
		if object_to_spawn == "cutable":
			spawn_cutable_object(spawn_pos)
		else:
			spawn_bomb(spawn_pos)
		
		await get_tree().create_timer(delay_between_objects).timeout

func spawn_cutable_object(spawn_pos) -> void:
	var new_object = cutable_object.instantiate()
	new_object.global_position = spawn_pos
	add_child(new_object)
			
	new_object.connect("successful_cut", Callable(self, "_on_successful_cut"))
	new_object.connect("object_missed", Callable(self, "_on_object_missed"))
	objects_spawned += 1

func spawn_bomb(spawn_pos) -> void:
	var new_object = noncutable_object.instantiate()
	new_object.global_position = spawn_pos
	add_child(new_object)
	new_object.connect("bomb_hit", Callable(self, "_on_bomb_hit"))
	bombs_spawned += 1

func _on_start_timer_timeout() -> void:
	_spawn_objects()

func _on_successful_cut() -> void:
	num_successful_cut += 1
	cuts_needed_label.text = str(cuts_needed - num_successful_cut)
	
	if num_successful_cut >= cuts_needed:
		game_finished.emit(PLAYER_WIN)

func _on_object_missed() -> void:
	num_misses += 1
	
	if num_misses >= max_objects:
		game_finished.emit(PLAYER_LOSE)
		print("player Lose")

func _on_bomb_hit() -> void:
	game_finished.emit(PLAYER_LOSE)
	print("Player hit bomb")
