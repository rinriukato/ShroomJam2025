extends ParallaxBackground

@export var speed : Vector2 = Vector2(50, 50) # pixels per second

func _process(delta):
	scroll_offset += speed * delta
