extends Area2D

var player_inside = false
var next_scene_path = "res://Scenes/main.tscn" 
var main
@onready var fade = $"../CharacterBody2D/Camera2D/fade"
@onready var interact_node = $"../CharacterBody2D/Camera2D/Interact"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	main = get_parent()

func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		player_inside = true
		if interact_node:
			interact_node.visible = true
		else:
			print("Interact node not found!")

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		player_inside = false
		if interact_node:
			interact_node.visible = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("E"):
		_change_scene()

func _change_scene() -> void:
	interact_node.visible = false
	fade.visible = true
	var c = fade.color
	c.a = 0
	fade.color = c
	fade.visible = true
	
	for i in range(100):
		c.a += 0.01
		fade.color = c
		await get_tree().process_frame
	
	var new_scene = load(next_scene_path).instantiate()
	var root = get_tree().root
	var current_scene = get_tree().current_scene
	
	root.add_child(new_scene)
	new_scene.owner = root
	
	main.get_node("Floor").queue_free()
	main.get_node("Wall").queue_free()
	main.get_node("Border").queue_free()
	main.get_node("Furniture").queue_free()
	main.get_node("Furniture2").queue_free()

	c.a = 1
	fade.color = c
	for i in range(100):
		c.a -= 0.01
		fade.color = c
		await get_tree().process_frame
	main.get_node("Area2D").queue_free()
	fade.visible = false
