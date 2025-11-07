extends Node

var current_level = null;

@onready var game_manager := $GameManager

func _ready() -> void:
	$GameUI.connect("button_1_pressed", handle_level_changed_1)
	$GameUI.connect("button_2_pressed", handle_level_changed_2)

func handle_level_changed_1() -> void:
	var next_level = load("res://Scenes/Microgames/test1.tscn").instantiate()
	call_deferred("add_child", next_level)
	# Connect signals or something here
	
	if (current_level != null):
		current_level.queue_free()
	current_level = next_level

func handle_level_changed_2() -> void:
	var next_level = load("res://Scenes/Microgames/test_2.tscn").instantiate()
	call_deferred("add_child", next_level)
	# Connect signals or something here
	
	if (current_level != null):
		current_level.queue_free()
	current_level = next_level
