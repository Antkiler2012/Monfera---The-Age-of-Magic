extends Area2D

@export var action_name = "E" 
@export var nodes_to_remove: Array = [] 

var player_inside = false
var main

func _ready():
	main = get_parent()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		player_inside = true
		_show_interact_prompt(body, true)

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		player_inside = false
		_show_interact_prompt(body, false)

func _process(delta):
	if player_inside and Input.is_action_just_pressed(action_name):
		_on_interact()

func _show_interact_prompt(player, visible):
	var interact_node = player.get_node_or_null("Camera2D/Interact")
	if interact_node:
		interact_node.visible = visible

func _on_interact():
	for name in nodes_to_remove:
		if main.has_node(name):
			main.get_node(name).queue_free()
	
	print("Interaction triggered!")
