extends Node

@onready var player = $"../Player" as Player

func _ready():
	player.player_died.connect(reset_ghosts)
	
func reset_ghosts():
	var ghosts = get_children() as Array[Ghost]
	
	for ghost in ghosts:
		if player.lifes == 0:
			ghost.set_process(false)
		else:
			ghost.setup()
