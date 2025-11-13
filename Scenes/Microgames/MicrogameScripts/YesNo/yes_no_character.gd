extends Sprite2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("a_key"):
		frame = 2
	elif Input.is_action_pressed("d_key"):
		frame = 1
	elif Input.is_action_just_pressed("w_key"):
		frame = 0
	elif Input.is_action_just_pressed("s_key"):
		frame = 1
