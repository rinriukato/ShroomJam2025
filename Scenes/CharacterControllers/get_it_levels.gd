extends Node

signal level_complete

func _ready() -> void:
	var objective = find_child("FruitObjective")
	
	objective.connect("item_get", Callable(self, "_on_objective_get"))
	
func _on_objective_get() -> void:
	print('ITEM GET')
	level_complete.emit()
