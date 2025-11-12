extends Microgame


@onready var start_timer := $StartTimer
@export var start_wait_time : float  = 1.5
@export var max_landing_speed : float = 500


var LEVEL_1 = preload("res://Scenes/Microgames/MicrogameScripts/Land/land_level_1.tscn")
var LEVEL_2 = preload("res://Scenes/Microgames/MicrogameScripts/Land/land_level_2.tscn")
var LEVEL_3 = preload("res://Scenes/Microgames/MicrogameScripts/Land/land_level_3.tscn")

var current_level
var in_landing_zone : bool = false
var space_character

func apply_difficulty(difficulty : int) -> void:
	if difficulty == LEVEL.EASY:
		_load_level(LEVEL_1)
	elif difficulty == LEVEL.NORMAL:
		_load_level(LEVEL_2)
	elif  difficulty == LEVEL.HARD:
		_load_level(LEVEL_3)
	else:
		print("A mistake has occured in difficulty! Setting to easy")
		_load_level(LEVEL_1)

func _ready() -> void:
	apply_difficulty(difficulty)
	start_timer.start(start_wait_time)


func _load_level(new_level) -> void:
	current_level = new_level.instantiate()
	call_deferred("add_child", current_level)
	
	space_character = current_level.find_child("SpaceCharacter")
	
	if space_character != null:
		space_character.connect("landed", Callable(self, "_on_space_character_landed"))
	else:
		print("Space Character not found?")
		get_tree().quit()
	
	var landing_zone = current_level.find_child("LandZone")
	
	if landing_zone != null:
		landing_zone.connect("body_entered", Callable(self, "_on_land_zone_body_entered"))
		landing_zone.connect("body_exited", Callable(self, "_on_land_zone_body_exited"))
	else:
		print("LandingZone not found?")
		get_tree().quit()


## Give time to the player to see where they need to go before
## descending
func _on_start_timer_timeout() -> void:
	space_character.enable_movement()

func _on_space_character_landed(landing_speed: float) -> void:
	if landing_speed <= max_landing_speed and in_landing_zone:
		game_finished.emit(PLAYER_WIN)
		print("Player Wins!")
	elif landing_speed > max_landing_speed and in_landing_zone:
		print("Player landed at a too high velocity")
		game_finished.emit(PLAYER_LOSE)
	elif landing_speed <= max_landing_speed and not in_landing_zone:
		print("Player landed at the wrong location!")
		game_finished.emit(PLAYER_LOSE)
	else:
		print("Player crashed!")
		game_finished.emit(PLAYER_LOSE)

func _on_land_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_landing_zone = true

func _on_land_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_landing_zone = false
