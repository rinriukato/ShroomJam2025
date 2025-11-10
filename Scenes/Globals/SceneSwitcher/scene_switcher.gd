extends Node

signal microgame_timeout

const MICROGAME_EAT_THIS = preload("res://Scenes/Microgames/eat_this.tscn")
const MICROGAME_SHOOT = preload("res://Scenes/Microgames/shoot.tscn")
const MICROGAME_SUPLEX = preload("res://Scenes/Microgames/suplex.tscn")
const MICROGAME_YES_NO = preload("res://Scenes/Microgames/yes_no.tscn")
const MICROGAME_GET_IT = preload("res://Scenes/Microgames/get_it.tscn")
const MICROGAME_JUMP = preload("res://Scenes/Microgames/jump.tscn")
const MICROGAME_LAND = preload("res://Scenes/Microgames/land.tscn")

@onready var game_manager := $GameManager
@onready var microgame_timer := $MicrogameTimer
@onready var game_ui := $GameUI

@export var microgame_wait_time : float = 10.0
@export_range(1.0, 3.0) var game_speed : float = 1.0

var current_difficulty_level : int = 0
var current_points : int = 0
var current_lives : int = 4
var current_level = null;
var current_game_index : int = 0
var game_array = []

func _ready() -> void:
	game_array.append(MICROGAME_SHOOT)
	game_array.append(MICROGAME_SUPLEX)
	game_array.append(MICROGAME_YES_NO)
	game_array.append(MICROGAME_EAT_THIS)
	game_array.append(MICROGAME_GET_IT)
	game_array.append(MICROGAME_JUMP)
	game_array.append(MICROGAME_LAND)
	microgame_timer.wait_time = microgame_wait_time


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		if current_game_index < game_array.size():
			_hide_game_ui()
			_handle_level_load(game_array[current_game_index])
			current_game_index += 1
			microgame_timer.start()


func _handle_level_load(microgame) -> void:
	var next_level = microgame.instantiate()
	call_deferred("add_child", next_level)
	
	next_level.connect("game_finished", Callable(self, "_on_game_finished"))
	self.connect("microgame_timeout", Callable(next_level, "on_microgame_timeout"))
	
	current_level = next_level


func _handle_level_unloading() -> void:
	if (current_level != null):
		microgame_timer.stop()
		self.disconnect("microgame_timeout", Callable(current_level, "on_microgame_timeout"))
		current_level.queue_free()


func _on_game_finished(player_win: bool) -> void:
	_show_game_ui()
	
	if player_win:
		current_points += 1
		print("Player won!")
	else:
		print("Player lost microgame")
		current_lives -= 1
		game_ui.remove_heart()
		
		if current_lives <= 0:
			get_tree().quit()
	
	# Do some animation for points?
	
	_handle_level_unloading()

func _show_game_ui() -> void:
	game_ui.visible = true

func _hide_game_ui() -> void:
	game_ui.visible = false

func _on_microgame_timer_timeout() -> void:
	print("timer finished in sceneswitcher node")
	microgame_timeout.emit()
