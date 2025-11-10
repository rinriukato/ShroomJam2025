extends Microgame


@onready var start_timer := $StartTimer
@onready var space_character := $SpaceCharacter

@export var start_wait_time : float  = 1.5
@export var max_landing_speed : float = 500

var in_landing_zone : bool = false

func _ready() -> void:
	start_timer.start(start_wait_time)
	
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
