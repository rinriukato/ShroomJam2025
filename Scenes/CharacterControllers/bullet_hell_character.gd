extends CharacterBody2D

signal player_death

@export var max_health : int = 10
@export var speed : float  = 400.0
@export var slow_speed : float = 150.0
@export var bullet_fire_rate: float = 0.2
@export var invincibility_time : float = 0.05

@onready var bullet_fire_rate_timer := $BulletFireRateTimer
@onready var invincibility_timer := $InvincibilityTimer

var is_player_invincible : bool = false
var can_shoot : bool = true
var health : int
var bullet_prefab = preload("res://Scenes/Microgames/MicrogameScripts/Boss/mahjong_tile_bullet.tscn")

func _ready() -> void:
	health = max_health

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("a_key", "d_key", "w_key", "s_key")
	
	##  Movement
	if Input.is_action_pressed("RMB"):
			velocity = direction * slow_speed
	else:
		velocity = direction * speed
	
	## Shooting
	if Input.is_action_pressed("LMB") and can_shoot:
		can_shoot = false
		bullet_fire_rate_timer.start(bullet_fire_rate)
		var new_bullet = bullet_prefab.instantiate()
		new_bullet.global_position = global_position
		get_parent().add_child(new_bullet)
		
	
	move_and_slide()

func take_damage(damage : int) -> void:
	if is_player_invincible:
		print("is invincible")
		return
	
	health -= damage
	is_player_invincible = true
	invincibility_timer.start(invincibility_time)
	
	if health <= 0:
		print("player death")
		player_death.emit()
		queue_free()

func _on_bullet_fire_rate_timer_timeout() -> void:
	can_shoot = true

func _on_invincibility_timer_timeout() -> void:
	is_player_invincible = false
	print('is not invincible')
