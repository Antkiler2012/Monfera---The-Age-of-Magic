extends Area2D

@export var action_name = "E" 
@export var nodes_to_remove: Array = [] 

var player_inside = false
var main
var Night_trans_run = false
	
@onready var Main = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Dialog")
@onready var Night = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Night")
@onready var NightTint = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Night/ColorRect")
@onready var camera = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D")
@onready var kai = get_tree().get_root().get_node("Node2D/Kai")
@onready var Pawmont = get_tree().get_root().get_node("Node2D/Pawmont")
@onready var Objective = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Objective")
@onready var interact_node = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Interact")
var current_dialog_index = 0
var dialog_started = false

var dialogs = [
	{
		"name": "Pawmont",
		"text": "Ah! Just in time. The Magical River feels… a bit restless tonight. You feel it too, right? The Cradle of Magic hasn’t glowed like this in ages…",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"option1": "Restless? What do you mean?",
		"option2": "Should we be worried?",
		"option3": "Maybe it’s just the sunset.",
		"option4": "(Stay quiet)",
		"next_option1": 1, 
		"next_option2": 2,  
		"next_option3": 3, 
		"next_option4": 4,  
		"enter": false,
	},

	{
		"name": "Etherling",
		"text": "When the Magical River moves like this, it’s… unpredictable. Could be exciting, could be trouble.",
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
		"text": "If only sunsets hummed like the Magical River… this is something different.",
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
		"text": "By the way, tomorrow is the Festival of Light.",
		"image": preload("res://images/Pawmont_character/Face.png"),
		"next": 6,
		"enter": false,
	},
		{
		"name": "Kai",
		"text": "Aight, first one to get a monfera wins, once you catch a monfera come back here",
		"image": preload("res://images/Kai_character/face.png"),
		"next": 6,
		"option1": "Aight",
		"option2": "What?",
		"option3": false,
		"option4": false,
		"next_option1": 7, 
		"next_option2": 8,  
		"enter": false,
	},
	{
		"name": "Kai",
		"text": "Aight, three, two, one GO!",
		"image": preload("res://images/Kai_character/face.png"),
		"next": null,
		"enter": true,
	},
		{
		"name": "Kai",
		"text": "ARE YOU DUMB?first one to get a monfera wins, once you catch a monfera come back here whats so hard about it?",
		"image": preload("res://images/Kai_character/face.png"),
		"next": 6,
		"option1": "Aight",
		"option2": "What?",
		"option3": false,
		"option4": false,
		"next_option1": 7, 
		"next_option2": 8,  
		"enter": false,
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
	if interact_node:
		interact_node.visible = visible

func _on_interact():
	for name in nodes_to_remove:
		if main.has_node(name):
			main.get_node(name).queue_free()
	start_dialog_sequence()
	interact_node.visible = false

	
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

		if data.get("text", "") == "Aight, three, two, one GO!":
			await get_tree().create_timer(1).timeout
			Objective.get_node("Label").text = "Go to the forest and catch a monfera"
			var target_pos = kai.position + Vector2(1000, 0)
			kai.get_node("Sprite2D").texture = load("res://images/Kai_character/right.png")
			var tween = create_tween()
			tween.tween_property(kai, "position", target_pos, 20).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
			await tween.finished

		if current_dialog_index == 5:
			if kai:
				var target_pos = kai.position + Vector2(-550, 0)
				var tween = create_tween()
				tween.tween_property(kai, "position", target_pos, 6).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
				await tween.finished

				var start_index = dialogs.size()
				dialogs.append_array([
					{
						"name": "Kai",
						"text": "There you are! I’ve been waiting. Do you think you can catch a Monfera before me?",
						"image": preload("res://images/Kai_character/face.png"),
						"option1": "Aight bet",
						"option2": "I dont want to make you cry.",
						"option3": false,
						"option4": false,
						"next_option1": start_index + 1,
						"next_option2": start_index + 2,
						"enter": false,
					},
					{
						"name": "Kai",
						"text": "Aight then, don’t cry when I win.",
						"image": preload("res://images/Kai_character/face.png"),
						"next": null,
					},
					{
						"name": "Kai",
						"text": "Ha! You wish. I’ll be the one waiting for you to catch up.",
						"image": preload("res://images/Kai_character/face.png"),
						"next": null,
					}
				])

				current_dialog_index = 9
				await show_current_dialog()
			else:
				push_error("Kai node not found! Check the node path.")



func try_progress_dialog():
	if current_dialog_index < dialogs.size():
		var current_data = dialogs[current_dialog_index]
		var next_val = current_data.get("next", null)
		if current_data.has("next_option1") and Main.last_option == "option1":
			next_val = current_data["next_option1"]
		elif current_data.has("next_option2") and Main.last_option == "option2":
			next_val = current_data["next_option2"]
		elif current_data.has("next_option3") and Main.last_option == "option3":
			next_val = current_data["next_option3"]
		elif current_data.has("next_option4") and Main.last_option == "option4":
			next_val = current_data["next_option4"]
		if next_val == null:
			await get_tree().create_timer(0.25).timeout
			Main.hide_dialog()
			if not Night_trans_run:
				if Night:
					Night.visible = true
					var start_color = NightTint.color
					start_color.a = 0
					NightTint.color = start_color

				if camera and NightTint:
					var tween = create_tween()
					var target_pos = camera.position + Vector2(6800, 0)
					tween.tween_property(camera, "position", target_pos, 5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
					
					var start_color2 = NightTint.color
					var end_color = start_color2
					end_color.a = 0.6
					tween.tween_property(NightTint, "color", end_color, 2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

					await tween.finished
					var pawmont_target_pos = kai.position + Vector2(-500000, 0)
					var pawmont_tween = create_tween()
					pawmont_tween.tween_property(Pawmont, "position", pawmont_target_pos, 0)
					
					await get_tree().create_timer(2).timeout
					Night_trans_run = true

					camera.position = Vector2(0, 0)
					current_dialog_index = 6
					await show_current_dialog()
			return

		current_dialog_index = next_val
		await show_current_dialog()

func _unhandled_input(event):
	if Main.Menu.visible:
		get_viewport().set_input_as_handled()
		return

	var pressed = false
	if event.is_action_pressed("ui_accept"):
		pressed = true
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pressed = true
	if not pressed:
		return

	var current_data = {}
	if current_dialog_index < dialogs.size():
		current_data = dialogs[current_dialog_index]

	var can_enter = current_data.get("enter", true)

	if not Main.typing_finished:
		Main.skip_typing = true
		get_viewport().set_input_as_handled()
		return

	if not can_enter:
		get_viewport().set_input_as_handled()
		return

	await try_progress_dialog()
