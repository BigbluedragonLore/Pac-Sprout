class_name UI
extends CanvasLayer

signal game_over

@export var main_scene: Node2D

@onready var center_container = $MarginContainer/CenterContainer
@onready var life_count_label = %LifeCountLabel
@onready var game_score_label = %GameScoreLabel
@onready var game_score_label_2 = %GameScoreLabel2
@onready var game_label = %GameLabel
@onready var button = $MarginContainer/CenterContainer/Panel/Button
@onready var texture_rect = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var texture_rect_2 = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect2
@onready var texture_rect_3 = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect3
@onready var v_box_container = $MarginContainer/VBoxContainer
@onready var texture_rect_background = $TextureRect




func set_lifes(lifes):
#	life_count_label.text = "%d UP" % lifes
	if lifes == 3:
		texture_rect.show()
		texture_rect_2.show()
		texture_rect_3.show()
	elif lifes == 2:
		texture_rect.show()
		texture_rect_2.show()
		texture_rect_3.hide()
	elif lifes == 1:
		texture_rect.show()
		texture_rect_2.hide()
		texture_rect_3.hide()
	elif lifes == 0:
		texture_rect.hide()
		texture_rect_2.hide()
		texture_rect_3.hide()
		game_lost()

func set_score(score):
	game_score_label.text = "SCORE:%d" % score
	game_score_label_2.text = "SCORE:%d" % score

func game_lost():
	game_label.text = "GAME OVER"
	center_container.show()
	v_box_container.hide()
	texture_rect_background.hide()
	game_over.emit()

func game_won():
	game_label.text = "GAME WON!"
	center_container.show()
	v_box_container.hide()
	texture_rect_background.hide()

func _on_button_pressed():
	main_scene.get_tree().reload_current_scene()
