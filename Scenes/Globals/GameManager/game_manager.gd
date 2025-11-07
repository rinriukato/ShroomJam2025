extends Node

@export var max_lives : int = 4
@export_range(1.0, 3.0) var game_speed : float = 1.0

var current_difficulty_level : int = 0
var current_points : int = 0
var current_lives : int = 4

func get_current_lives() -> int:
	return current_lives

func increment_points():
	current_points += 1

func reset_points():
	current_points = 0
	
func increment_lives():
	current_lives = min(current_lives + 1, max_lives)

func decrement_lives():
	current_lives -= max(current_lives - 1, 0)
