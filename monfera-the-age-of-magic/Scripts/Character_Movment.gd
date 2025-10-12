extends CharacterBody2D

@export var grid_size: int = 3
@export var move_speed: float = 100
@export var enabled: bool = false 

@onready var sprite = $Sprite2D

var sprite_up   = load("res://images/Character/Up.png")
var sprite_down = load("res://images/Character/Down.png")
var sprite_left = load("res://images/Character/Left.png")
var sprite_right = load("res://images/Character/Right.png")

var target_position: Vector2
var moving: bool = false

func _ready():
	target_position = position

func _physics_process(delta):
	if moving:
		var step = move_speed * delta
		position = position.move_toward(target_position, step)
		if position == target_position:
			moving = false
	else:
		if enabled:
			handle_input()

func handle_input():
	var dir_x = Vector2.ZERO
	var dir_y = Vector2.ZERO

	if Input.is_action_pressed("Up"):
		dir_y = Vector2.UP
		sprite.texture = sprite_up
	elif Input.is_action_pressed("Down"):
		dir_y = Vector2.DOWN
		sprite.texture = sprite_down
	if Input.is_action_pressed("Left"):
		dir_x = Vector2.LEFT
		sprite.texture = sprite_left
	elif Input.is_action_pressed("Right"):
		dir_x = Vector2.RIGHT
		sprite.texture = sprite_right

	if Input.is_action_pressed("ui_home"):
		move_speed = 100
	else:
		move_speed = 5
		
	if dir_x != Vector2.ZERO or dir_y != Vector2.ZERO:
		var motion = (dir_x * grid_size) + (dir_y * grid_size)
		var collision = move_and_collide(motion)

func die():
	get_tree().call_deferred("reload_current_scene")
