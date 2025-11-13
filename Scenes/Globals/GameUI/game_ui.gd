extends Control

const max_hearts : int = 4
enum POSES {IDLE, HAPPY, SAD}

@onready var heartbar := $HeartBar
@onready var score_label := $Score

#Sprite Animation Players
@onready var main_character_anim_player := $MainKyrata/AnimationPlayer
@onready var radical_roy_anim_player := $RadicalRoy/AnimationPlayer
@onready var other_contestant_anim_player := $IdkContestant3/AnimationPlayer
@onready var duck_host_anim_player := $DuckHost/AnimationPlayer

@onready var main_character_sprite := $MainKyrata

var heart_icons = []
var num_hearts : int = 4
var score : int = 0:set = set_score


func _ready() -> void:
	main_character_anim_player.play("idle")
	radical_roy_anim_player.play("idle")
	other_contestant_anim_player.play("idle")
	duck_host_anim_player.play("idle")
	
	
	for heart in heartbar.get_children():
		heart_icons.append(heart)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("a_key"):
		change_mc_pose(POSES.IDLE)
	if Input.is_action_just_pressed("s_key"):
		change_mc_pose(POSES.HAPPY)
	if Input.is_action_just_pressed("d_key"):
		change_mc_pose(POSES.SAD)
	pass



func set_score(new_value : int) -> void:
	if score == new_value:
		return
	score = new_value
	
	# Update labels
	score_label.text = str(score)

func remove_heart() -> void:
	if num_hearts <= 0:
		return
	
	var heart = heart_icons[num_hearts - 1]
	heart.visible = false
	num_hearts -= 1

func add_heart() -> void:
	if num_hearts >= max_hearts:
		return
	
	var heart = heart_icons[num_hearts]
	heart.visible = true
	num_hearts += 1

func change_mc_pose(pose : int) -> void:
	if pose == POSES.IDLE:
		main_character_sprite.frame = POSES.IDLE
	elif pose == POSES.HAPPY:
		main_character_sprite.frame = POSES.HAPPY
	elif pose == POSES.SAD:
		main_character_sprite.frame = POSES.SAD
