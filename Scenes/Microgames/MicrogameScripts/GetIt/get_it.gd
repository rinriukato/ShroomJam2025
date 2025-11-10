extends Microgame

signal microgame_timeout

const LEVEL_1 = preload("res://Scenes/CharacterControllers/get_it_level_1.tscn")
const LEVEL_2 = preload("res://Scenes/CharacterControllers/get_it_level_2.tscn")
const LEVEL_3 = preload("res://Scenes/CharacterControllers/get_it_level_3.tscn")

var level_array = []
var current_level

func _ready() -> void:
	level_array.append(LEVEL_1)
	level_array.append(LEVEL_2)
	level_array.append(LEVEL_3)
	
	_load_level(level_array[randi_range(0, level_array.size() - 1)])

func _load_level(new_level) -> void:
	current_level = new_level.instantiate()
	call_deferred("add_child", current_level)
	
	current_level.connect("level_complete", Callable(self, "_on_game_finished"))

func _on_game_finished() -> void:
	current_level.queue_free()
	game_finished.emit(PLAYER_WIN)
