extends CharacterBody2D

@export var bullet_speed : float = 1000

@onready var sprite := $Sprite2D

func _ready() -> void:
	sprite.frame = randi_range(0,4)

func _physics_process(delta: float) -> void:
	velocity = Vector2.UP * bullet_speed
	
	move_and_slide()

func _on_expire_timer_timeout() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("boss_hitbox"):
		var parent = area.get_parent()
		if parent.has_method("take_damage"):
			parent.take_damage(1)
			queue_free()
