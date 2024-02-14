class_name Ghost
extends Area2D

signal runaway_timeout

enum GhostState {
	SCATTER, 
	CHASE,
	RUN_AWAY,
	EATEN,
	STARTING_AT_HOME
}

var current_scatter_index = 0
var current_at_home_index = 0
var movement_direction = Vector2.ZERO

var current_state: GhostState

@export var eaten_speed = 200
@export var speed= 70
@export var start_at_home_speed= 35
@export var movement_targets: Resource
@export var tile_map: MazeTileMap
@export var chasing_target: Node2D
@export_enum("Red", "Blue","Green", "Yellow") var coloration: int
@export var point_manager: PointManager
@export var is_starting_at_home = false
@export var scatter_wait_time = 8
@export var starting_position: Node2D
@export var eat_ghost_sound: AudioStreamPlayer2D

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var anim_tree = $AnimationTree
@onready var scatter_timer = $ScatterTimer
@onready var update_chasing_target_position_timer = $UpdateChasingTargetPositionTimer
@onready var run_away_timer = $RunAwayTimer
@onready var point_label = $PointLabel
@onready var at_home_timer = $AtHomeTimer




func _ready():
	at_home_timer.timeout.connect(scatter)
	scatter_timer.wait_time = scatter_wait_time
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	navigation_agent_2d.target_reached.connect(on_position_reached)
	
	call_deferred("setup")

func _process(delta):
	move_ghost(navigation_agent_2d.get_next_path_position(), delta)

func move_ghost(next_position: Vector2, delta : float):
	var current_ghost_position = global_position
	var current_speed
#	var current_speed = eaten_speed if current_state == GhostState.EATEN else speed
	if current_state == GhostState.EATEN:
		current_speed = eaten_speed
	elif current_state == GhostState.STARTING_AT_HOME:
		current_speed = start_at_home_speed
	else:
		current_speed = speed
		
	var new_velocity = (next_position - current_ghost_position).normalized() * current_speed * delta
	position += new_velocity
	movementDirection(new_velocity)

func scatter():
	scatter_timer.start()
	current_state = GhostState.SCATTER
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index].position

func setup():
	position = starting_position.position
	navigation_agent_2d.set_navigation_map(tile_map.get_navigation_map(0))
	NavigationServer2D.agent_set_map(navigation_agent_2d.get_rid(), tile_map.get_navigation_map(0))
	if is_starting_at_home:
		start_at_home()
	else:
		scatter()

func start_at_home():
	current_state = GhostState.STARTING_AT_HOME
	at_home_timer.start()
#	at_home_timer.timeout.connect(scatter)
	navigation_agent_2d.target_position = movement_targets.at_home_targets[current_at_home_index].position

func on_position_reached():
	if current_state == GhostState.SCATTER:
		scatter_position_reached()
	elif current_state == GhostState.CHASE:
		chase_position_reached()
	elif current_state == GhostState.RUN_AWAY:
		run_away_from_pacman()
	elif current_state == GhostState.EATEN:
		start_chasing_pacman()
	elif current_state == GhostState.STARTING_AT_HOME:
		move_to_next_home_position()

func move_to_next_home_position():
	current_at_home_index = 1 if current_at_home_index == 0 else 0
	navigation_agent_2d.target_position = movement_targets.at_home_targets[current_at_home_index].position

func chase_position_reached():
	print("Kill Pacman")

func scatter_position_reached():
	if current_scatter_index < 3:
		current_scatter_index += 1
	else:
		current_scatter_index = 0
	navigation_agent_2d.target_position = movement_targets.scatter_targets[current_scatter_index].position

func movementDirection(new_velocity):
	if new_velocity.x <0:
		anim_tree.set("parameters/blend_position", Vector2.LEFT)
	if new_velocity.x >0:
		anim_tree.set("parameters/blend_position", Vector2.RIGHT)

func _on_scatter_timer_timeout():
	start_chasing_pacman()

func start_chasing_pacman():
	if chasing_target == null:
		print("NO CHASING_TARGET")
	current_state = GhostState.CHASE
	update_chasing_target_position_timer.start()
	navigation_agent_2d.target_position = chasing_target.position

func _on_update_chasing_target_position_timer_timeout():
	navigation_agent_2d.target_position = chasing_target.position

func run_away_from_pacman():
	if run_away_timer.is_stopped():
		run_away_timer.start()
		
	current_state = GhostState.RUN_AWAY
	
	#stop timers
	update_chasing_target_position_timer.stop()
	scatter_timer.stop()
	
	var empty_cell_position = tile_map.get_random_empty_cell_position()
	navigation_agent_2d.target_position = empty_cell_position


func _on_run_away_timer_timeout():
	runaway_timeout.emit()
	start_chasing_pacman()

func get_eaten():
	eat_ghost_sound.play()
	point_label.show()
	point_label.text = "%d" % point_manager.points_for_eaten_ghost
	await point_manager.pause_on_ghost_eaten()
	point_label.hide()
	run_away_timer.stop()
	runaway_timeout.emit()
	current_state = GhostState.EATEN
	navigation_agent_2d.target_position = movement_targets.at_home_targets[0].position
	


func _on_body_entered(body):
	var player = body as Player
	if current_state == GhostState.RUN_AWAY:
		get_eaten()
	elif current_state == GhostState.CHASE || current_state == GhostState.SCATTER:
		update_chasing_target_position_timer.stop()
		player.die()
		scatter_timer.wait_time = 5
		scatter()

