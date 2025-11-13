extends Sprite2D

signal item_get

@onready var audio_stream := $AudioStreamPlayer

func _ready() -> void:
	frame = randi_range(0, 37)
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	item_get.emit()
	audio_stream.play()
