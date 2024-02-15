extends Node

var total_pellets_count
var pellets_eaten = 0

@export var ghost_array: Array[Ghost]
@export var pellets_array: Array

@onready var ui = $"../UI"
@onready var point_manager = $"../PointManager"
@onready var eat_pellets = $"../SoundPlayers/EatPellets"
@onready var eat_big_pelets = $"../SoundPlayers/EatBigPelets"
@onready var music_player = $"../SoundPlayers/MusicPlayer"
@onready var horror_player = $"../SoundPlayers/HorrorPlayer"

var eaten_ghost_counter = 0


func _ready():
	music_player.play()
	pellet_aray_reset()
#	pellets_array = self.get_children() as Array[Pellet]
	total_pellets_count = pellets_array.size()
	for pellet in pellets_array:
		pellet.pellet_eaten.connect(on_pellet_eaten)
		if pellet.is_in_group("BigPellet"):
			total_pellets_count -=1
	
#	var pellets = self.get_children() as Array[Pellet]
#	total_pellets_count = pellets.size()
#	for pellet in pellets:
#		pellet.pellet_eaten.connect(on_pellet_eaten)
#		if pellet.is_in_group("BigPellet"):
#			total_pellets_count -=1
	
	for ghost in ghost_array:
		ghost.runaway_timeout.connect(on_ghost_run_away_timeout)
	
	print(total_pellets_count)
		
func on_pellet_eaten(should_allow_eating_gosts: bool):
#	pellets_eaten += 1
#	var pellets = self.get_children() as Array[Pellet]
#	pellets_array = self.get_children() as Array[Pellet]
	pellet_aray_reset()
	
	if should_allow_eating_gosts:
		if horror_player.is_playing():
			return
		else:
			eat_big_pelets.play()
			horror_player.play()
			music_player.stream_paused = true
			for ghost in ghost_array:
				if ghost.current_state != ghost.GhostState.STARTING_AT_HOME:
					ghost.run_away_from_pacman()
			for pellet in pellets_array:
				if pellet.is_in_group("BigPellet"):
					pellet.hide()
#					pellet.monitoring = false
					pellet.set_deferred("monitoring", false)
#					pellet.set_deferred(CollisionShape2D, true)
#	if should_allow_eating_gosts:
#		eat_big_pelets.play()
#		horror_player.play()
#		music_player.stream_paused = true
#		for ghost in ghost_array:
#			if ghost.current_state != ghost.GhostState.STARTING_AT_HOME:
#				ghost.run_away_from_pacman()
	else:
		pellets_eaten += 1
		eat_pellets.play()
		print(pellets_array)
	
	if pellets_eaten == total_pellets_count:
		ui.game_won()
	
func on_ghost_run_away_timeout():
	eaten_ghost_counter +=1
	if eaten_ghost_counter == ghost_array.size():
		horror_player.stop()
		music_player.stream_paused = false
		eaten_ghost_counter = 0
		point_manager.reset_points_for_ghosts()
		
#		var pellets = self.get_children() as Array[Pellet]
		pellet_aray_reset()
		for pellet in pellets_array:
			if pellet.is_in_group("BigPellet"):
				pellet.show()
#				pellet.monitoring = true
				pellet.set_deferred("monitoring", true)
#				pellet.set_deferred(true)
		
func pellet_aray_reset():
	pellets_array = self.get_children() as Array[Pellet]
