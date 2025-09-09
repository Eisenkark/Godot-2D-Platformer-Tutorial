extends Node
@onready var score_label: Label = $UILayer/ScoreLabel

var points: int = 0

func add_points(point_val: int = 0):
	points += point_val
	
	## Score label has different variables, to set the text we call score_label.text = "text"
	## Godot requires that you cast variables to Strings if you're trying to add a string and an integer or float
	score_label.text = "Score: " + str(points)
