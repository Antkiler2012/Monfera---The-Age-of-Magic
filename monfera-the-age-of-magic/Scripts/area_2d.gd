extends Area2D

var player_inside = false
var next_scene_path = "res://Scenes/main.tscn" 
var main
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	main = get_parent()

func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		player_inside = true
		var interact_node = body.get_node_or_null("Camera2D/Interact")
		if interact_node:
			interact_node.visible = true
		else:
			print("Interact node not found!")

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		player_inside = false
		var interact_node = body.get_node_or_null("Camera2D/Interact")
		if interact_node:
			interact_node.visible = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("E"):
		_change_scene()

func _change_scene():
	var new_scene = load(next_scene_path).instantiate()
	main.get_node("Floor").queue_free()
	main.get_node("Wall").queue_free()
	main.get_node("Border").queue_free()
	main.get_node("Furniture").queue_free()
	main.get_node("Furniture2").queue_free()
	main.get_node("Area2D").queue_free()
	if not new_scene:
		print("Failed to load scene!")
		return
	if get_tree().current_scene:
		get_tree().current_scene.free()
	get_tree().current_scene = new_scene
	get_tree().root.add_child(new_scene)
