class_name UI
extends CanvasLayer

signal game_over

@export var main_scene: Node2D

@onready var center_container = $MarginContainer/CenterContainer
@onready var life_count_label = %LifeCountLabel
@onready var game_score_label = %GameScoreLabel
@onready var game_label = %GameLabel
@onready var button = $MarginContainer/CenterContainer/Panel/Button



func set_lifes(lifes):
	life_count_label.text = "%d UP" % lifes
	if lifes == 0:
		game_lost()

func set_score(score):
	game_score_label.text = "SCORE: %d" % score

func game_lost():
	game_label.text = "GAME OVER"
	center_container.show()
	game_over.emit()

func game_won():
	game_label.text = "GAME WON"
	center_container.show()

func _on_button_pressed():
	main_scene.get_tree().reload_current_scene()
