extends Sprite2D

signal target_destroyed

var half_width = texture.get_width() / 2
var half_height = texture.get_height() / 2

@export var speed : float = 300
@export_enum("Vertical", "Horizontal") var movement_mode : String = "Vertical"
@export var can_move : bool = false

var is_mouse_on : bool = false
var interactions_enabled : bool = true
var direction : int = 1

func set_movement(new_mode : String) -> void:
	if new_mode == "Vertical":
		movement_mode = new_mode
		can_move = true
	elif new_mode == "Horizontal":
		movement_mode = new_mode
		can_move = true
	else:
		print("Invalid movement mode: " + new_mode)

func set_speed(new_speed : float) -> void:
	speed = new_speed

func disable_interactions() -> void:
	interactions_enabled = false

func _process(delta: float) -> void:
	if not interactions_enabled:
		return
	
	if Input.is_action_just_pressed("LMB") and is_mouse_on:
		print("Shot at target!")
		emit_signal("target_destroyed")
		queue_free()
	
	if can_move:
		var screen_size = get_viewport_rect().size
		
		if movement_mode == "Horizontal":
			position.x += speed * direction * delta
			
			if position.x < half_width or position.x > screen_size.x - half_width:
				direction *= -1
			
		elif movement_mode == "Vertical":
			position.y += speed * direction * delta
			
			if position.y < half_height or position.y > screen_size.y - half_height:
				direction *= -1

func _on_area_2d_mouse_entered() -> void:
	is_mouse_on = true


func _on_area_2d_mouse_exited() -> void:
	is_mouse_on = false
