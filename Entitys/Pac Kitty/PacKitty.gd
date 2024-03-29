class_name Player
extends CharacterBody2D

signal player_died(lifes: int)

@export var speed = 100
@export var death: Color
@export var start_position: Node2D
@export var death_player: AudioStreamPlayer2D
@export var ui: UI

@onready var pointer = $Pointer
@onready var direction_pointer = $Pointer/DirectionPointer
@onready var collision_shape = $CollisionShape2D
@onready var anim_tree = $AnimationTree
@onready var state_machine = anim_tree.get("parameters/playback") 
@onready var sprite_2d = $Sprite2D
@onready var anim_player = $AnimationPlayer





var lifes: int = 2
var next_direction = Vector2.ZERO
var movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()

func _ready():
	shape_query.shape = collision_shape.shape
	shape_query.collision_mask = 2
	ui.set_lifes(lifes)
	
func reset_player():
	sprite_2d.modulate = Color(1,1,1,1)
	position = start_position.position
	next_direction = Vector2.ZERO
	movement_direction = Vector2.ZERO
	set_physics_process(true)
	set_collision_layer_value(1, true)
	
 
func _physics_process(delta):
	get_input()
	
	if movement_direction == Vector2.ZERO:
		movement_direction = next_direction
	if can_move_in_direction(next_direction, delta):
		movement_direction = next_direction
	
	velocity = movement_direction * speed
	
	move_and_slide()
	state_machine_update(velocity)
	animation_direction_update(movement_direction)

func get_input():
	
	if Input.is_action_pressed("left"):
		next_direction = Vector2.LEFT
		pointer.rotation_degrees = 0
	if Input.is_action_pressed("right"):
		next_direction = Vector2.RIGHT
		pointer.rotation_degrees = 180
	if Input.is_action_pressed("down"):
		next_direction = Vector2.DOWN
		pointer.rotation_degrees = 270
	if Input.is_action_pressed("up"):
		next_direction = Vector2.UP
		pointer.rotation_degrees = 90
		
func can_move_in_direction(dir: Vector2, delta: float) -> bool:
	shape_query.transform = global_transform.translated(dir * speed * delta * 2)
	var result = get_world_2d().direct_space_state.intersect_shape(shape_query)
	return result.size() == 0

func state_machine_update(velocity):
	if velocity != Vector2.ZERO:
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")

func animation_direction_update(movement_direction):
	anim_tree.set("parameters/walk/blend_position", movement_direction)
	
func die():
	death_player.play()
	sprite_2d.modulate = death
	set_physics_process(false)
	set_collision_layer_value(1, false)
	state_machine.travel("idle")
	await get_tree().create_timer(1.0).timeout
	if death_player.finished:
		lifes -= 1
		ui.set_lifes(lifes)
		player_died.emit()
		if lifes !=0:
			reset_player()
