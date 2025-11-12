extends Microgame

@export_group("Level 1")
@export var level_1_car_speed : float = 2000.0
@export var level_1_can_jump : bool = false

@export_group("Level 2")
@export var level_2_car_speed : float = 2750.0
@export var level_2_can_jump : bool = false

@export_group("Level 3")
@export var level_3_car_speed : Array[float] =  [level_1_car_speed, level_2_car_speed]
# This car jumps randomly

@onready var car := $Car
@onready var start_timer := $StartTimer
@onready var warning_sign := $WarningSprite

@export_group("wait times")
@export var min_wait_time : int = 2
@export var max_wait_time : int = 6

var car_speed : float = 2000.0
var can_jump : float = false


func apply_difficulty(difficulty : int) -> void:
	randomize()
	if difficulty == LEVEL.EASY:
		car_speed = level_1_car_speed
		can_jump = level_1_can_jump
	elif difficulty == LEVEL.NORMAL:
		car_speed = level_2_car_speed
		can_jump = level_2_can_jump
	elif  difficulty == LEVEL.HARD:
		car_speed = level_3_car_speed.pick_random()
		can_jump = randf() < 0.5
	else:
		print("A mistake has occured in difficulty! Setting to easy")
		car_speed = level_1_car_speed
		can_jump = level_1_can_jump

func _ready() -> void:
	apply_difficulty(difficulty)
	_start_game()

func _start_game() -> void:
	warning_sign.show_blinker()
	car.set_speed(car_speed)
	car.set_can_jump(can_jump)
	
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
