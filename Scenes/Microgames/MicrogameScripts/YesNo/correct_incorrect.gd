extends Node2D

signal finished_correct_incorrect

@onready var correct_sprite := $Correct
@onready var incorrect_sprite := $Incorrect
@onready var correct_sound := $CorrectSound
@onready var incorrect_sound := $IncorrectSound
@onready var timer := $Timer

func _ready() -> void:
	correct_sprite.visible = false
	incorrect_sprite.visible = false

func correct() -> void:
	correct_sprite.visible = true
	correct_sound.play()
	timer.start()

func incorrect() -> void:
	incorrect_sprite.visible = true
	incorrect_sound.play()
	timer.start()

func _on_timer_timeout() -> void:
	correct_sprite.visible = false
	incorrect_sprite.visible = false
	finished_correct_incorrect.emit()
