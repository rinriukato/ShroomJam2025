extends Microgame

@onready var car := $Car
@onready var start_timer := $StartTimer
@onready var warning_sign := $WarningSprite

@export var min_wait_time : int = 2
@export var max_wait_time : int = 6


func _ready() -> void:
	_start_game()

func _start_game() -> void:
	warning_sign.show_blinker()
	
	var wait_time = randi_range(min_wait_time, max_wait_time)
	print(wait_time)
	start_timer.start(wait_time)
	
	pass

func _on_car_hit_player() -> void:
	game_finished.emit(PLAYER_LOSE)
	print("Player hit by car :(!")

func _on_start_timer_timeout() -> void:
	car.can_go = true
	pass

func on_microgame_timeout() -> void:
	game_finished.emit(PLAYER_WIN)

func _on_end_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		game_finished.emit(PLAYER_WIN)

func _on_jump_area_body_entered(body: Node2D) -> void:
	print("Detected car in jump zone?")
	if body.is_in_group("car") and body.has_method("jump"):
		body.jump()
