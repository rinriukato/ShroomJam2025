extends Control

const max_hearts : int = 4

@onready var heartbar := $HeartBar

var heart_icons = []
var num_hearts : int = 4

func _ready() -> void:
	for heart in heartbar.get_children():
		heart_icons.append(heart)

func remove_heart() -> void:
	if num_hearts <= 0:
		return
	
	var heart = heart_icons[num_hearts - 1]
	heart.visible = false
	num_hearts -= 1

func add_heart() -> void:
	if num_hearts >= max_hearts:
		return
	
	var heart = heart_icons[num_hearts]
	heart.visible = true
	num_hearts += 1
