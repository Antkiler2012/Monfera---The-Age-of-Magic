extends Node2D

@onready var Main = $CharacterBody2D/Camera2D/Dialog

var char

var dialogs = [
	{
		"name": "Etherling",
		"text": "Ah! Hello, Antoni. You’re finally awake. My name is Etherling, I’ll be your guide on this journey.",
		"image": preload("res://images/magical_ghost.png")
	},
	{
		"name": "Etherling",
		"text": "Let’s get you moving. Use WASD to walk around, and press E to interact with objects.",
		"image": preload("res://images/magical_ghost.png")
	},
	{
		"name": "Etherling",
		"text": "Great! Now try exploring the outside a bit. There’s so much to see!",
		"image": preload("res://images/magical_ghost.png")
	}
]

var current_dialog_index = 0
var dialog_started = false

func _ready():
	char = $CharacterBody2D
	if Main == null:
		push_error("Dialog node not found! Check your node path.")
	else:
		start_dialog_sequence()
		
		


func start_dialog_sequence():
	if dialog_started:
		return
	dialog_started = true
	await get_tree().create_timer(4).timeout
	show_current_dialog()


func show_current_dialog():
	if Main and current_dialog_index < dialogs.size():
		var data = dialogs[current_dialog_index]
		await Main.Show_Dialog(data["name"], data["text"], data["image"])
		if current_dialog_index == 0:
			char.enabled = true 



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or \
	   (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):

		if not Main:
			return

		if not Main.typing_finished:
			Main.skip_typing = true  # skip current line
		else:
			current_dialog_index += 1
			if current_dialog_index < dialogs.size():
				show_current_dialog()
			else:
				Main.hide_dialog()
