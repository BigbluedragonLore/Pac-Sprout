extends Node2D

@onready var left_area_2d = $LeftColorRect/LeftArea2D
@onready var right_area_2d = $RightColorRect/RightArea2D
@onready var left_coll = $LeftColorRect/LeftArea2D/LeftCollisionShape2D
@onready var right_coll = $RightColorRect/RightArea2D/RightCollisionShape2D


var allow_left_transitioin = true
var allow_right_transitioin = true
var player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _on_left_area_2d_body_entered(body):
	if allow_left_transitioin:
		body.position.x = right_coll.global_position.x
		allow_right_transitioin = false

func _on_left_area_2d_body_exited(body):
	if allow_left_transitioin == false:
		allow_left_transitioin = true

func _on_right_area_2d_body_entered(body):
	if allow_right_transitioin:
		body.position.x = left_coll.global_position.x
		allow_left_transitioin = false

func _on_right_area_2d_body_exited(body):
	if allow_right_transitioin == false:
		allow_right_transitioin = true




