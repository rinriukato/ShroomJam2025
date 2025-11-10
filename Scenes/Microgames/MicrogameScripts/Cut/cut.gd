extends Microgame

@export var cuts_needed : int = 3
@export var max_objects : int = 5
@export var delay_between_objects : float = 0.7

@onready var spawn_points := $SpawnPoints
@onready var start_timer := $StartTimer
@onready var cuts_needed_label := $CanvasLayer/Control/HBoxContainer/Label2

var cutable_object = preload("res://Scenes/Microgames/MicrogameScripts/Cut/cutable_object.tscn")
var spawn_positions : Array[Vector2]
var num_successful_cut : int = 0
var num_misses : int = 0

func _ready() -> void:
	_get_spawn_positions()

func _get_spawn_positions() -> void:
	for node : Node2D in spawn_points.get_children():
		spawn_positions.append(node.global_position)

func _spawn_objects() -> void:
	var positions = spawn_positions.duplicate()
	
	for i in range(max_objects):
		positions.shuffle()
		var spawn_pos = positions.pop_back()
		var new_object = cutable_object.instantiate()
		new_object.global_position = spawn_pos
		add_child(new_object)
		
		new_object.connect("successful_cut", Callable(self, "_on_successful_cut"))
		new_object.connect("object_missed", Callable(self, "_on_object_missed"))
		await get_tree().create_timer(delay_between_objects).timeout


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
