extends Microgame

signal microgame_timeout

## Easy Group
const LEVEL_1 = preload("res://Scenes/CharacterControllers/get_it_level_1.tscn")
const LEVEL_2 = preload("res://Scenes/CharacterControllers/get_it_level_2.tscn")
const LEVEL_3 = preload("res://Scenes/CharacterControllers/get_it_level_3.tscn")

## Normal Group
const LEVEL_4 = preload("res://Scenes/Microgames/MicrogameScripts/GetIt/get_it_level_4.tscn")
const LEVEL_5 = preload("res://Scenes/Microgames/MicrogameScripts/GetIt/get_it_level_5.tscn")

## Hard Group
const LEVEL_6 = preload("res://Scenes/Microgames/MicrogameScripts/GetIt/get_it_level_6.tscn")
const LEVEL_7 = preload("res://Scenes/Microgames/MicrogameScripts/GetIt/get_it_level_7.tscn")

var level_array = []
var current_level

func apply_difficulty(difficulty : int) -> void:
	if difficulty == LEVEL.EASY:
		level_array.append(LEVEL_1)
		level_array.append(LEVEL_2)
		level_array.append(LEVEL_3)
	elif difficulty == LEVEL.NORMAL:
		level_array.append(LEVEL_4)
		level_array.append(LEVEL_5)
	elif  difficulty == LEVEL.HARD:
		level_array.append(LEVEL_6)
		level_array.append(LEVEL_7)
	else:
		print("A mistake has occured in difficulty! Setting to easy")
		level_array.append(LEVEL_1)
		level_array.append(LEVEL_2)
		level_array.append(LEVEL_3)
	
	level_array.shuffle()

func _ready() -> void:
	apply_difficulty(difficulty)
	
	_load_level(level_array.pop_front())

func _load_level(new_level) -> void:
	current_level = new_level.instantiate()
	call_deferred("add_child", current_level)
	
	current_level.connect("level_complete", Callable(self, "_on_game_finished"))
	current_level.connect("player_death", Callable(self, "_on_game_failed"))

func _on_game_finished() -> void:
	current_level.queue_free()
	game_finished.emit(PLAYER_WIN)

func _on_game_failed() -> void:
	current_level.queue_free()
	game_finished.emit(PLAYER_LOSE)
