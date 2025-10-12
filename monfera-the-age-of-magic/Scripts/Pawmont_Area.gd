extends Area2D

@export var action_name = "E" 
@export var nodes_to_remove: Array = [] 

var player_inside = false
var main

@onready var Main = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Dialog")


var current_dialog_index = 0
var dialog_started = false

var dialogs = [
	{
		"name": "Pawmont",
		"text": "Ah, Antoni! Just in time. The Etherflow feels restless tonight. You sense it too, don’t you? The Cradle of Magic has been glowing brighter than ever…",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"option1": "Yeah",
		"option2": "No?",
		"option3": false,
		"option4": false,
		"next_option1": 1, 
		"next_option2": 2  
	},

	{
		"name": "Etherling",
		"text": "Great! I knew you’d feel it too. Let’s get moving and explore the Etherflow together!",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"option1": "test",
		"option2": "test_two?",
		"option3": false,
		"option4": false,
		"next_option1": 3, 
		"next_option2": 4,
	},

	{
		"name": "Etherling",
		"text": "Hmm, that’s odd. Maybe you need to focus more. Take a deep breath and try to sense it again.",
		"image": preload("res://images/Pawmont_character/Face.png"),
	},
	{
		"name": "Etherling",
		"text": "Test",
		"image": preload("res://images/Pawmont_character/Face.png"),
	},
		{
		"name": "Etherling",
		"text": "Test two",
		"image": preload("res://images/Pawmont_character/Face.png"),
	},
]


func _ready():
	main = get_parent()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_option_selected(option_index: int) -> void:
	var current_data = dialogs[current_dialog_index]

	if option_index == 1 and current_data.has("next_option1"):
		current_dialog_index = current_data["next_option1"]
	elif option_index == 2 and current_data.has("next_option2"):
		current_dialog_index = current_data["next_option2"]
	elif option_index == 3 and current_data.has("next_option3"):
		current_dialog_index = current_data["next_option3"]
	elif option_index == 4 and current_data.has("next_option4"):
		current_dialog_index = current_data["next_option4"]
	elif current_data.has("next"):
		current_dialog_index = current_data["next"]
	else:
		current_dialog_index += 1

	if current_dialog_index < dialogs.size():
		show_current_dialog()
	else:
		Main.hide_dialog()


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
	start_dialog_sequence()

	
func start_dialog_sequence():
	if dialog_started:
		return
	dialog_started = true
	show_current_dialog()



func show_current_dialog():
	if Main and current_dialog_index < dialogs.size():
		var data = dialogs[current_dialog_index]

		var options = {}
		for i in range(1, 5):
			var key = "option%d" % i
			if data.has(key):
				options[key] = data[key]

		await Main.Show_Dialog(data["name"], data["text"], data["image"], options)
		
		Main.option_callback = Callable(self, "_on_option_selected")
		
func _unhandled_input(event: InputEvent) -> void:
	if Main.Menu.visible:
		return

	if not Main.typing_finished:
		if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
			Main.skip_typing = true
		return

	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		current_dialog_index += 1
		if current_dialog_index < dialogs.size():
			show_current_dialog()
		else:
			Main.hide_dialog()
