extends Control

@onready var button = $Button
var simultaneous_scene = preload("res://Scenes/main.tscn").instantiate()
@onready var fade = $fade

func _ready():
	print("ready")
	var c = fade.color
	c.a = 0
	fade.color = c
	button.pressed.connect(play)

func play() -> void:
		button.disabled = true
		var i = 0
		var c = fade.color
		c.a = 0
		while i < 100:
			c.a += 0.01
			fade.color = c
			await get_tree().create_timer(0.01).timeout 
			i += 1
		get_tree().root.add_child(simultaneous_scene)
		await get_tree().create_timer(2).timeout
		i = 0
		while i < 100:
			c.a -= 0.01
			fade.color = c
			await get_tree().create_timer(0.01).timeout 
			i += 1
		var music = get_tree().root.get_node("Node2D/AudioStreamPlayer2D")
		music.play()
		
