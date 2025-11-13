extends Node

signal microgame_timeout

const MICROGAMES = [
	{"title": "Eat This!", "scene": preload("res://Scenes/Microgames/eat_this.tscn")},
	{"title": "Shoot!", "scene": preload("res://Scenes/Microgames/shoot.tscn")},
	{"title": "Suplex!", "scene": preload("res://Scenes/Microgames/suplex.tscn")},
	{"title": "Yes or No?", "scene": preload("res://Scenes/Microgames/yes_no.tscn")},
	{"title": "Get It!", "scene": preload("res://Scenes/Microgames/get_it.tscn")},
	{"title": "Jump!", "scene": preload("res://Scenes/Microgames/jump.tscn")},
	{"title": "Land!", "scene": preload("res://Scenes/Microgames/land.tscn")},
	{"title": "Cut!", "scene": preload("res://Scenes/Microgames/cut.tscn")},
]

const MICROGAME_BOSS = {"title": "Defeat the Boss!", "scene": preload("res://Scenes/Microgames/boss.tscn")}

@onready var microgame_timer := $MicrogameTimer
@onready var game_ui := $GameUI
@onready var microgame_title := $MicrogameTitle
@onready var rest_timer := $RestTimer
@onready var show_title_timer := $ShowTitleTimer
@onready var transition_anim_player := $Transition/TransitionAnimation
@onready var transition_panel := $Transition

@export var starting_wait_time : float = 3.0
@export var rest_wait_time : float = 5.0
@export var microgame_wait_time : float = 10.0
@export_range(1.0, 3.0) var game_speed : float = 1.0
@export var next_difficulty_threshold : int = 11

var current_difficulty_level : int = 0
var current_points : int = 0
var current_lives : int = 4
var current_level = null
var microgame_queue = []
var next_game

func _ready() -> void:
	transition_anim_player.play("fadein")
	await transition_anim_player.animation_finished
	transition_panel.visible = false
	
	microgame_timer.wait_time = microgame_wait_time
	rest_timer.wait_time = rest_wait_time
	show_title_timer.wait_time = rest_wait_time / 2
	
	await get_tree().create_timer(starting_wait_time).timeout
	_rest_between_round()


func _handle_level_load(microgame) -> void:
	var next_level = microgame.instantiate()
	next_level.init(current_difficulty_level)
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
	if current_level == null:
		return

	_show_game_ui()
	
	if player_win:
		current_points += 1
		game_ui.set_score(current_points)
		print("Player won!")
	else:
		print("Player lost microgame")
		current_lives -= 1
		game_ui.remove_heart()
		
		if current_lives <= 0:
			get_tree().quit()
	
	# Do some animation for points?
	
	_handle_level_unloading()
	_rest_between_round()

func _rest_between_round() -> void:
	if current_points >= next_difficulty_threshold and current_difficulty_level < 2:
		next_difficulty_threshold += next_difficulty_threshold
		current_difficulty_level += 1
		microgame_title.set_title_and_play('LEVEL UP!')
		await get_tree().create_timer(3.0).timeout
		
	rest_timer.start()
	show_title_timer.start()
	
	if current_points != 0 and current_points % 10 == 0:
		next_game = MICROGAME_BOSS
		
	else:
		if microgame_queue.size() <= 0:
			_add_games_to_queue()
		next_game = microgame_queue.pop_front()
		
	

func _set_up_next_round() -> void:
	_hide_game_ui()
	
	if next_game["title"] != MICROGAME_BOSS["title"]:
		microgame_timer.start()
		
	_handle_level_load(next_game["scene"])

func _show_game_ui() -> void:
	game_ui.visible = true

func _hide_game_ui() -> void:
	game_ui.visible = false

func _add_games_to_queue() -> void:
	microgame_queue.clear()

	for microgame in MICROGAMES:
		microgame_queue.append(microgame)

	microgame_queue.shuffle()

func _on_microgame_timer_timeout() -> void:
	microgame_timeout.emit()

func _on_rest_timer_timeout() -> void:
	_set_up_next_round()

func _on_show_title_timer_timeout() -> void:
	microgame_title.set_title_and_play(next_game["title"])
