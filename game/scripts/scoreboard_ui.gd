extends Control

@onready var score_label = $Panel/VBoxContainer/Score
@onready var time_label = $Panel/VBoxContainer/Time
@onready var grade_label = $Panel/Label/Grade
@onready var retry_bttn = $Panel/Button
@onready var comment = $Comment
@onready var animation_player = $AnimationPlayer

var points := 0

func _ready() -> void:
	points = 0
	# grading system
	animation_player.play("RESET")
	if ScoreboardInfo.time < 20:
		points += 50
	elif ScoreboardInfo.time < 30:
		points += 25
	
	var score_to_total_ratio = float(ScoreboardInfo.score) / ScoreboardInfo.total_possible_score
	
	points += (score_to_total_ratio * 50)
	
	if points >= 90:
		grade_label.text = "A"
		grade_label.add_theme_color_override("font_color", Color("green"))
	elif points >= 80:
		grade_label.text = "b"
		grade_label.add_theme_color_override("font_color", Color("blue"))
	elif points >= 70:
		grade_label.text = "c"
		grade_label.add_theme_color_override("font_color", Color("purple"))
	else:
		grade_label.text = "f"
		grade_label.add_theme_color_override("font_color", Color("red"))
		
	time_label.text = format_time(ScoreboardInfo.time)
	score_label.text = str(ScoreboardInfo.score)
	
	animation_player.play("entrance")
	await animation_player.animation_finished
	retry_bttn.grab_focus()

func format_time(time) -> String:
	var time_string := ""
	
	time_string += str(time/60) + ":" + str(time % 60)
	
	return time_string


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn") # Replace with function body.
