extends Node

const target = preload("res://Scenes/Microgames/MicrogameScripts/Shoot/target.tscn")

@export var max_targets_needed : int = 3

var target_instances = []
var target_destroyed : int = 0

func _ready() -> void:
	var screen_size = get_viewport().size
	
	for i in range(max_targets_needed):
		var instance = target.instantiate()
		var random_x_pos = randi_range(0, screen_size.x)
		var random_y_pos = randi_range(0, screen_size.y)
		
		instance.position = Vector2(random_x_pos, random_y_pos)
		instance.connect("target_destroyed", _on_target_destroyed)
		target_instances.append(instance)
		add_child(instance)

func _on_target_destroyed():
	print("target destroyed!")
	target_destroyed += 1
	if target_destroyed >= max_targets_needed:
		print("Player Win!")
		get_tree().quit()
