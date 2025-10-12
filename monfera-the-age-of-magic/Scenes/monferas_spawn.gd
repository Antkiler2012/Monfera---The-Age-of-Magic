extends Area2D

var check = false
var done = false

@onready var you_caught = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/you_caught")
@onready var Objective = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Objective")
@onready var kai = get_tree().get_root().get_node("Node2D/Kai/Area2D")

func _ready():
	randomize()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	start_random_check() 


func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		check = true

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		check = false


func start_random_check() -> void:
	await get_tree().process_frame 
	while true:
		await get_tree().create_timer(2.5).timeout
		if check:
			if done == false:
				var num = randi_range(0, 10)
				if num == 1:
					print("The random number is 1!")
					you_caught.visible = true
					await get_tree().create_timer(2.5).timeout
					you_caught.visible = false
					Objective.get_node("Label").text = "Go back to the town"
					kai.enabled = true
					done = true
				else:
					print("yea")
