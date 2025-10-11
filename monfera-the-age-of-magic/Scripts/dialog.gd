extends CanvasLayer

@onready var Dialog = $Dialog
@onready var Dialog_Name = $Dialog/Name
@onready var Dialog_Text = $Dialog/Text
@onready var Dialog_Image = $Dialog/TextureRect
@onready var Menu = $Menu

var typing_speed := 0.03
var typing_finished := false

@onready var click_sound = preload("res://sound/click2.ogg")
@onready var audio_player = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(audio_player)
	audio_player.volume_db = -30

func Show_Dialog(Name: String, Text: String, Char_Image: Texture2D) -> void:
	Dialog.visible = true
	Dialog_Name.text = Name
	Dialog_Image.texture = Char_Image
	typing_finished = false
	Dialog_Text.text = ""
	await type_text(Text)

func type_text(full_text: String) -> void:
	for i in full_text.length():
		Dialog_Text.text += full_text[i]
		play_click()
		await get_tree().create_timer(typing_speed).timeout
	typing_finished = true

func play_click() -> void:
	audio_player.stream = click_sound
	audio_player.play()

func hide_dialog() -> void:
	Dialog.visible = false
