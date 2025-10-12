extends CharacterBody2D

@export var speed = 50
@export var path_points: Array = [] 
var current_point = 0


func _ready():
	if path_points.size() > 0:
		global_position = path_points[0]

func _physics_process(delta):
	if path_points.size() == 0:
		return

	var target = path_points[current_point]
	var direction = (target - global_position).normalized()

	velocity = direction * speed
	move_and_slide()

	if global_position.distance_to(target) < 5:
		current_point = (current_point + 1) % path_points.size()
	
		
