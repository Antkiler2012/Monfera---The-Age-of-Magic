extends CanvasLayer

# UI Nodes
@onready var Dialog = $Dialog
@onready var Dialog_Name = $Dialog/Name
@onready var Dialog_Text = $Dialog/Text
@onready var Dialog_Image = $Dialog/TextureRect

# Variables
var char: CharacterBody2D
var typing_speed := 0.03
var typing_finished := false
var skip_typing := false

# Audio
@onready var click_sound = preload("res://sound/click2.ogg")
@onready var audio_player = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(audio_player)
	audio_player.stream = click_sound
	audio_player.volume_db = -30
	char = get_parent().get_parent()


func Show_Dialog(name: String, text: String, image: Texture2D) -> void:
	Dialog.visible = true
	Dialog_Name.text = name
	Dialog_Image.texture = image
	Dialog_Text.text = ""
	typing_finished = false
	skip_typing = false

	await type_text(text)


func type_text(full_text: String) -> void:
	for i in range(full_text.length()):
		if skip_typing:
			Dialog_Text.text = full_text
			break

		Dialog_Text.text += full_text[i]

		if i % 2 == 0 and not audio_player.playing:
			audio_player.play()

		await get_tree().create_timer(typing_speed).timeout

	typing_finished = true
	skip_typing = false


func hide_dialog() -> void:
	Dialog.visible = false
