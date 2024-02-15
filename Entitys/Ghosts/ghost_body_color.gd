extends Sprite2D

@onready var anim_player = $"../AnimationPlayer"


@export var run1: Color
@export var run2: Color
@export var normal: Color

var red=preload("res://Entitys/Sprites/Chicken/chicken red.png")
var blue=preload("res://Entitys/Sprites/Chicken/chicken blue.png")
var green=preload("res://Entitys/Sprites/Chicken/chicken green.png")
var yellow=preload("res://Entitys/Sprites/Chicken/chicken default.png")

var ghost_color

func _ready():
	ghost_color = get_parent().coloration
	setup_color()


func setup_color():
	if ghost_color == 0:
		set_texture(red)
	if ghost_color == 1:
		set_texture(blue)
	if ghost_color == 2:
		set_texture(green)
	if ghost_color == 3:
		set_texture(yellow)

func _process(delta):
	var parent = get_parent()
	if parent.current_state == 2:
		anim_player.play("runaway")
	elif parent.current_state == 3:
		anim_player.stop()
		blink_1()
	else:
		anim_player.stop()
		normal_color()
		
func blink_1():
	self.modulate = run1
	
func blink_2():
	self.modulate = run2

func normal_color():
	self.modulate = normal
	
