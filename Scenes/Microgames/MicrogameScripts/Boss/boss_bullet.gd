extends CharacterBody2D

@export var bullet_speed: float = 800.0
@export var move_independently : bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not move_independently: return
	
	var forward = Vector2.RIGHT.rotated(rotation)
	
	velocity = forward * bullet_speed
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hitbox"):
		var parent = area.get_parent()
		if parent.has_method("take_damage"):
			parent.take_damage(1)
			queue_free()
