extends Node2D

@onready var animation_player = $CanvasLayer/AnimationPlayer
@onready var time_label = $CanvasLayer/GridContainer/time
@onready var score_label = $CanvasLayer/GridContainer/score

var time := 0
var score := 0

const SCORE_INCREMENT := 100

func _ready() -> void:
	time_label.text = format_time()
	score_label.text = str(score)
	ScoreboardInfo.score = score
	ScoreboardInfo.time = time
	


func _on_dojo_body_entered(_body: Node2D) -> void:
	animation_player.play("fade_out") # Replace with function body.
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/scoreboard.tscn")


func _on_timer_timeout() -> void:
	time_label.text = format_time() # Replace with function body.
	time += 1
	ScoreboardInfo.time = time
	
func format_time() -> String:
	var time_string := ""
	
	time_string += str(time/60) + ":" + str(time % 60)
	
	return time_string


func _on_enemy_frog_area_entered(area: Area2D) -> void:
	if area.visible:
		score += SCORE_INCREMENT
		ScoreboardInfo.score = score
		score_label.text = str(score)
