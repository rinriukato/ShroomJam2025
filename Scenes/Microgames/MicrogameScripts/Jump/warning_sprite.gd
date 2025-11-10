extends Sprite2D

@onready var anim_player := $AnimationPlayer

func show_blinker() -> void:
	anim_player.play("blink")
