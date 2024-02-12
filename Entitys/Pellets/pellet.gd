class_name Pellet
extends Area2D

@export var should_allow_eating_gosts = false

signal pellet_eaten()

func _on_body_entered(body):
	if body is Player:
		pellet_eaten.emit()
		queue_free()
		if should_allow_eating_gosts:
			pass
