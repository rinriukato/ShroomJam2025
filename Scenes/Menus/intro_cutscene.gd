extends Control

@onready var anim_player := $AnimationPlayer

func _ready() -> void:
	anim_player.play("intro_cutscene")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print('anim done')
	get_tree().change_scene_to_file("res://Scenes/Globals/SceneSwitcher/scene_switcher.tscn")
