extends Line2D

var queue: Array 
@export var max_length : int = 20


func _process(_delta: float) -> void:
	var global_pos = get_global_mouse_position()
	var pos = to_local(global_pos)
	
	queue.push_front(pos)
	
	if queue.size() > max_length:
		queue.pop_back()
	
	clear_points()
	
	for point in queue:
		add_point(point)
