extends Control

@onready var bar := $HBoxContainer

enum dir {UP, DOWN, LEFT, RIGHT}

var arrow_up := preload("res://Assets/Sprites/Suplex/arrow.png")
var arrow_down := preload("res://Assets/Sprites/Suplex/arrow_down.png")
var arrow_left := preload("res://Assets/Sprites/Suplex/arrow_left.png")
var arrow_right := preload("res://Assets/Sprites/Suplex/arrow_right.png")

var input_array : Array[TextureRect] = []

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("a_key"):
		_add_arrow_to_display(dir.LEFT)
	if Input.is_action_just_pressed("d_key"):
		_add_arrow_to_display(dir.RIGHT)
	if Input.is_action_just_pressed("w_key"):
		_add_arrow_to_display(dir.UP)
	if Input.is_action_just_pressed("s_key"):
		_add_arrow_to_display(dir.DOWN)
	
	#if Input.is_action_just_pressed("debug"):
		#clear_inputs()

func _add_arrow_to_display(direction) -> void:
	var new_arrow := TextureRect.new()
	
	if direction == dir.UP:
		new_arrow.texture = arrow_up
	if direction == dir.DOWN:
		new_arrow.texture = arrow_down
	if direction == dir.LEFT:
		new_arrow.texture = arrow_left
	if direction == dir.RIGHT:
		new_arrow.texture = arrow_right
	
	bar.add_child(new_arrow)
	
func clear_inputs() -> void:
	for node in bar.get_children():
		node.queue_free()
