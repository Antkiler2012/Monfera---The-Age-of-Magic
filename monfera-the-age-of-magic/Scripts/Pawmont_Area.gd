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
		"text": "Ah, Antoni! Just in time. The Etherflow feels… a bit restless tonight. You feel it too, right? The Cradle of Magic hasn’t glowed like this in ages…",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"option1": "Restless? What do you mean?",
		"option2": "Should we be worried?",
		"option3": "Maybe it’s just the sunset.",
		"option4": "(Stay quiet)",
		"next_option1": 1, 
		"next_option2": 2,  
		"next_option3": 3, 
		"next_option4": 4,  
	},

	{
		"name": "Etherling",
		"text": "When the Etherflow moves like this, it’s… unpredictable. Could be exciting, could be trouble.",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"next": 5,
	},

	{
		"name": "Etherling",
		"text": "Worried? Not really. But curiosity always pays off.",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"next": 5,
	},
	{
		"name": "Etherling",
		"text": "If only sunsets hummed like the Etherflow… this is something different.",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"next": 5,
	},
		{
		"name": "Etherling",
		"text": "Hmm… sometimes, the best way to understand magic is to simply watch it. Keep your senses open tonight",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"next": 5,
	},
	{
		"name": "Etherling",
		"text": "Tomorrow is the Festival of Light, of course. But tonight… the lake might show things no festival ever will.",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"next": 6,
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
		print("Showing dialog index:", current_dialog_index)
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
		var current_data = dialogs[current_dialog_index]
		if current_data.has("next"):
			current_dialog_index = current_data["next"]
		else:
			current_dialog_index += 1
			
		if current_dialog_index < dialogs.size():
			await show_current_dialog()
		else:
			await get_tree().create_timer(0.25).timeout
			Main.hide_dialog()
