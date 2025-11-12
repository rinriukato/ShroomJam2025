extends Node

signal level_complete
signal player_death

func _ready() -> void:
	var objective = find_child("FruitObjective")
	
	objective.connect("item_get", Callable(self, "_on_objective_get"))
	
	var death_zones = find_child("DeathZones")
	
	if death_zones != null:
		for zone in death_zones.get_children():
			zone.connect("body_entered", Callable(self, "_on_player_death"))
	
func _on_objective_get() -> void:
	print('ITEM GET')
	level_complete.emit()

func _on_player_death(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_death.emit()
		print("player died")
	
