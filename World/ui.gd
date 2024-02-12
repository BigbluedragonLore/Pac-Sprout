class_name UI
extends CanvasLayer

@onready var center_container = $MarginContainer/CenterContainer

func game_won():
	center_container.show()

