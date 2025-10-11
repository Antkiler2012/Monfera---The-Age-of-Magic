extends Node2D

@onready var Main = $CharacterBody2D/Camera2D/Dialog

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
		"text": "Great! Now try exploring the outside a bit. There’s so Much to see!",
		"image": preload("res://images/magical_ghost.png")
	}
]

var current_dialog_index = 0

func _ready():
	if Main == null:
		push_error("Dialog node not found! Check your node path.")
	else:
		Main_start()

func Main_start():
	if Main:
		await get_tree().create_timer(10).timeout
		show_current_dialog()

func show_current_dialog():
	if Main:
		var data = dialogs[current_dialog_index]
		Main.Show_Dialog(data["name"], data["text"], data["image"])

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Main == null:
			return
		if Main.typing_finished:
			current_dialog_index += 1
			if current_dialog_index < dialogs.size():
				show_current_dialog()
			else:
				Main.hide_dialog()
		else:
			var current = dialogs[current_dialog_index]
			Main.Dialog_Text.text = current["text"]
			Main.typing_finished = true
