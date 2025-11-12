extends Microgame


@onready var boss_enemy := $BossEnemy
@onready var player := $BulletHellCharacter

@onready var player_health_label := $CanvasLayer/VBoxContainer/PlayerInfo/Label2
@onready var boss_health_label := $CanvasLayer/VBoxContainer/BossInfo/Label2

func _process(_delta: float) -> void:
	if player.health != null:
		player_health_label.text = str(player.health)
	
	if boss_enemy.health != null:
		boss_health_label.text = str(boss_enemy.health)

func _on_boss_enemy_boss_death() -> void:
	game_finished.emit(PLAYER_WIN)


func _on_bullet_hell_character_player_death() -> void:
	game_finished.emit(PLAYER_LOSE)
