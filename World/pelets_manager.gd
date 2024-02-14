extends Node

var total_pellets_count
var pellets_eaten = 0

@export var ghost_array: Array[Ghost]

@onready var ui = $"../UI"
@onready var point_manager = $"../PointManager"
@onready var eat_pellets = $"../SoundPlayers/EatPellets"
@onready var eat_big_pelets = $"../SoundPlayers/EatBigPelets"
@onready var music_player = $"../SoundPlayers/MusicPlayer"
@onready var horror_player = $"../SoundPlayers/HorrorPlayer"

var eaten_ghost_counter = 0


func _ready():
	music_player.play()
	var pellets = self.get_children() as Array[Pellet]
	total_pellets_count = pellets.size()
	for pellet in pellets:
		pellet.pellet_eaten.connect(on_pellet_eaten)
	
	for ghost in ghost_array:
		ghost.runaway_timeout.connect(on_ghost_run_away_timeout)
		
		
func on_pellet_eaten(should_allow_eating_gosts: bool):
	pellets_eaten += 1
	
	if should_allow_eating_gosts:
		eat_big_pelets.play()
		horror_player.play()
		music_player.stream_paused = true
		for ghost in ghost_array:
			if ghost.current_state != ghost.GhostState.STARTING_AT_HOME:
				ghost.run_away_from_pacman()
	else:
		eat_pellets.play()
	
	if pellets_eaten == total_pellets_count:
		ui.game_won()
	
func on_ghost_run_away_timeout():
	eaten_ghost_counter +=1
	if eaten_ghost_counter == ghost_array.size():
		horror_player.stop()
		music_player.stream_paused = false
		eaten_ghost_counter = 0
		point_manager.reset_points_for_ghosts()
		
	
