class_name PointManager
extends Node

@onready var ui = $"../UI" as UI


var points_for_eaten_ghost = 200
var points = 0

func _ready():
	ui.game_over.connect(game_over)

func pause_on_ghost_eaten():
	points += points_for_eaten_ghost
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	points_for_eaten_ghost += 200
	ui.set_score(points)

func reset_points_for_ghosts():
	points_for_eaten_ghost = 200

func game_over():
#	get_tree().paused = true
	pass
