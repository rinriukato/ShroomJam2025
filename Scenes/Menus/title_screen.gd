extends Node


func _on_start_button_pressed() -> void:
	print("start pressed")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
