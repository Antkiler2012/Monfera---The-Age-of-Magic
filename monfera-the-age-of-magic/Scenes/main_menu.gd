extends Control

@onready var button = $Button
var simultaneous_scene = preload("res://Scenes/main.tscn").instantiate()

func _ready():
	print("ready")
	button.pressed.connect(play)

func play():
		get_tree().root.add_child(simultaneous_scene)
