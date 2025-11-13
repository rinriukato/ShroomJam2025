extends Node

@onready var anim_player := $ColorRect2/AnimationPlayer
@onready var transition := $ColorRect2

func _ready() -> void:
	anim_player.play("fadein")
	await anim_player.animation_finished
	transition.visible = false

func _on_story_button_pressed() -> void:
	transition.visible = true
	anim_player.play("fadeout")
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Menus/intro_cutscene.tscn")
