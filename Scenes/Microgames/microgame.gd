## Virtual base class for all microgames
class_name Microgame extends Node

const PLAYER_WIN : bool = true
const PLAYER_LOSE : bool = false

signal game_finished(player_win: bool)

## Default way for microgames to "lose" is through the scene switcher's timer
## timing out, therefore we need to connect this function to each microgame
## for this signal to fire.
func on_microgame_timeout() -> void:
	game_finished.emit(PLAYER_LOSE)
