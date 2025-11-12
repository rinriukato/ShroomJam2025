extends Microgame

@export var max_rounds : int = 5
@export var food_offset : int = -2
@onready var food_line := $FoodLine

var num_food : int = 25
var num_bombs : int = 25
var can_eat_food_array :Array[bool] = []
var food_model_array = []
var current_offset : int = 0
var food_eaten_safety : int = 0
var onigiri := preload("res://Assets/Model/EatThis/onigiri.tscn")
var onigiri_dynamite := preload("res://Assets/Model/EatThis/onigiri_dynamite.tscn")

func _ready() -> void:
	for i in num_food:
		can_eat_food_array.append(true)
	for i in num_bombs:
		can_eat_food_array.append(false)
	can_eat_food_array.shuffle()
	
	_spawn_food()
	
func _process(delta: float) -> void:
	# Player ran out of food before the minimum. Fail!
	if can_eat_food_array.size() <= 0:
		game_finished.emit(PLAYER_LOSE)
	
	if Input.is_action_just_pressed("a_key"):
		_eat_food(true)
	if Input.is_action_just_pressed("d_key"):
		_eat_food(false)
	
func _eat_food(did_eat_food : bool) -> void:
	var is_food_safe = can_eat_food_array.pop_front()
	var food_model = food_model_array.pop_front()
	
	if did_eat_food and is_food_safe:
		print("player got point! Food was safe")
		food_eaten_safety += 1
	elif did_eat_food and not is_food_safe:
		print("player ate a bomb")
		game_finished.emit(PLAYER_LOSE)
	elif not did_eat_food and is_food_safe:
		print("player tossed a good food")
	else:
		print("Player tossed a bomb!")
	
	
	food_model.queue_free()
	_shift_food_forward()
	
	if food_eaten_safety >= max_rounds:
		game_finished.emit(PLAYER_WIN)

func _spawn_food() -> void:
	for food in can_eat_food_array:
		var item
		
		if food == true:
			item = onigiri.instantiate()
		else:
			item = onigiri_dynamite.instantiate()
		
		food_line.add_child(item)
		item.global_position = food_line.global_position
		item.global_position.z += current_offset
		current_offset += food_offset
		
		food_model_array.append(item)

func _shift_food_forward() -> void:
	for food in food_model_array:
		food.global_position.z -= food_offset
