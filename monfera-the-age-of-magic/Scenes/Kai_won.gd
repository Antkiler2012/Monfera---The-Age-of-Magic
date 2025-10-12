extends Area2D

@export var action_name = "ui_accept"
@export var action_name_two = "E"
@export var scene_to_change = "res://Scenes/End.tscn"
@export var enabled: bool = false 
@onready var house = get_tree().get_root().get_node("House")
@onready var Main_scene = get_tree().get_root().get_node("Node2D")
var player_inside = false
var dialog_shown = false
@onready var Main = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Dialog")

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "CharacterBody2D":
		player_inside = true
		if enabled:
			_show_interact_prompt(true)

func _on_body_exited(body):
	if body.name == "CharacterBody2D":
		player_inside = false
		_show_interact_prompt(false)

func _show_interact_prompt(visible: bool):
	var interact_node = get_tree().get_root().get_node("House/CharacterBody2D/Camera2D/Interact")
	if interact_node:
		interact_node.visible = visible

func _process(delta):
	if player_inside and Input.is_action_just_pressed(action_name_two) and not dialog_shown:
		show_dialog()
func show_dialog() -> void:
	dialog_shown = true
	await Main.Show_Dialog("Kai", "HAHAHAH, I Won, you're so bad", preload("res://images/Kai_character/Front.png"))
	await wait_for_enter()
	_change_scene()
func wait_for_enter() -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed(action_name):
			break

func _change_scene():
	get_tree().change_scene_to_file(scene_to_change)
	Main_scene.get_node("River").queue_free()
	Main_scene.get_node("Houses").queue_free()
	Main_scene.get_node("Pathwalks").queue_free()
	Main_scene.get_node("Grass").queue_free()
	Main_scene.get_node("Trees,Bush").queue_free()
	Main_scene.get_node("Pawmont").queue_free()
	Main_scene.get_node("Kai").queue_free()
	Main_scene.get_node("Monferas_spawn").queue_free()
	house.get_node("CharacterBody2D").queue_free()
