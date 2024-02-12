class_name Player
extends CharacterBody2D

@export var speed = 120
@onready var pointer = $Pointer
@onready var direction_pointer = $Pointer/DirectionPointer
@onready var collision_shape = $CollisionShape2D
@onready var anim_tree = $AnimationTree
@onready var state_machine = anim_tree.get("parameters/playback") 




var next_direction = Vector2.ZERO
var movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()

func _ready():
	shape_query.shape = collision_shape.shape
#	shape_query.collide_with_areas = false
#	shape_query.collide_with_bodies = true
	shape_query.collision_mask = 2
 
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
	
