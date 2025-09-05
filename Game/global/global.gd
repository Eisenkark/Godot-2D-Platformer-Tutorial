extends Node
@onready var score_label: Label = $UILayer/ScoreLabel

var points: int = 0

func add_points(point_val: int = 0):
	points += point_val
	score_label.text = "Score: " + str(points)
