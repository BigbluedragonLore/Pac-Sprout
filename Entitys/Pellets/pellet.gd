class_name Pellet
extends Area2D

signal pellet_eaten(should_allow_eating_gosts: bool)

@export var should_allow_eating_gosts = false


func _on_body_entered(body):
	if body is Player:
		pellet_eaten.emit(should_allow_eating_gosts)
		queue_free()
