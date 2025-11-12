extends Label

@export var title := "": set = set_title_and_play
@onready var anim_player := $AnimationPlayer

func set_title_and_play(new_title: String) -> void:
	if title == new_title:
		return
	
	title = new_title
	text = new_title
	
	anim_player.play("show_title")

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("debug"):
		#anim_player.play("show_title")
