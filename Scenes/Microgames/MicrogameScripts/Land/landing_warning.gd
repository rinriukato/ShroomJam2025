extends Sprite2D


@onready var anim_player := $AnimationPlayer

func show_warning() -> void:
	visible = true

func hide_warning() -> void:
	visible = false
