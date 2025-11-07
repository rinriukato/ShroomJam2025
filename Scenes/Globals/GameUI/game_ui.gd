extends Control

@onready var lives_label := $LivesLabel
@onready var game_manager := $"../GameManager"

signal button_1_pressed
signal button_2_pressed

func _ready() -> void:
	_update_lives_text()

func _update_lives_text() -> void:
	var format_string = "Lives: {lives}"
	var actual_string = format_string.format({"lives": str(game_manager.get_current_lives())})
	lives_label.text = actual_string

func _on_button_button_down() -> void:
	emit_signal("button_1_pressed")

func _on_button_2_button_down() -> void:
	emit_signal("button_2_pressed")
