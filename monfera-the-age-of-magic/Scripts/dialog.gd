extends CanvasLayer

# UI Nodes
@onready var Dialog = $Dialog
@onready var Dialog_Name = $Dialog/Name
@onready var Dialog_Text = $Dialog/Text
@onready var Dialog_Image = $Dialog/TextureRect
@onready var Menu = $Menu
@onready var Menu_Option_1 = $Menu/Option_1
@onready var Menu_Option_2 = $Menu/Option_2
@onready var Menu_Option_3 = $Menu/Option_3
@onready var Menu_Option_4 = $Menu/Option_4


# Variables
var char: CharacterBody2D
var typing_speed := 0.03
var typing_finished := false
var skip_typing := false
var option_callback = Callable(self, "_dummy") 


# Audio
@onready var click_sound = preload("res://sound/click2.ogg")
@onready var audio_player = AudioStreamPlayer.new()

func _ready():
	Dialog = get_node_or_null("Dialog")
	Dialog_Name = Dialog.get_node_or_null("Name") if Dialog else null
	Dialog_Text = Dialog.get_node_or_null("Text") if Dialog else null
	Dialog_Image = Dialog.get_node_or_null("TextureRect") if Dialog else null

	Menu = get_node_or_null("Menu")
	Menu_Option_1 = Menu.get_node_or_null("Option_1") if Menu else null
	Menu_Option_2 = Menu.get_node_or_null("Option_2") if Menu else null
	Menu_Option_3 = Menu.get_node_or_null("Option_3") if Menu else null
	Menu_Option_4 = Menu.get_node_or_null("Option_4") if Menu else null

	add_child(audio_player)
	audio_player.stream = click_sound
	audio_player.volume_db = -30

func Show_Dialog(name: String, text: String, image: Texture2D, options: Dictionary = {}, callback = null) -> void:
	# Reset typing control
	typing_finished = false
	skip_typing = false

	# Show dialog elements
	Dialog.visible = true
	Dialog_Name.text = name
	Dialog_Image.texture = image
	Dialog_Text.text = ""

	# Hide menu while typing
	if Menu:
		Menu.visible = false

	# Set callback
	if callback != null:
		option_callback = callback
	else:
		option_callback = Callable(self, "_dummy")

	await type_text(text)

	_set_options(options)
	if options.size() > 0:
		Menu.visible = true

func _set_options(options: Dictionary) -> void:
	var option_nodes = [Menu_Option_1, Menu_Option_2, Menu_Option_3, Menu_Option_4]

	for i in range(4):
		var btn = option_nodes[i]
		if btn:
			for c in btn.get_signal_connection_list("pressed"):
				if c.has("target") and c.has("method"):
					btn.disconnect("pressed", c["target"], c["method"])

			var opt = options.get("option" + str(i+1), false)
			btn.visible = (typeof(opt) == TYPE_STRING and opt != "") or (typeof(opt) == TYPE_BOOL and opt)
			if btn.visible:
				btn.text = str(opt)
				btn.pressed.connect(func(idx=i+1) -> void:
					_on_option_pressed(idx))

func _on_option_pressed_button():
	var btn = get_tree().current_scene.get_focus_owner()
	if btn and btn.has_meta("option_index"):
		_on_option_pressed(btn.get_meta("option_index"))


func _dummy(option_index: int) -> void:
	pass

func _on_option_pressed(option_index: int) -> void:
	print("DEBUG: Option pressed, calling callback with", option_index)
	Menu.visible = false
	if option_callback.is_valid():
		print("DEBUG: Callback target:", option_callback.get_object())
		print("DEBUG: Callback method:", option_callback.get_method())
		option_callback.call(option_index)
	else:
		print("DEBUG: Callback invalid!")





func type_text(full_text: String) -> void:
	typing_finished = false
	skip_typing = false
	Dialog_Text.text = ""

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
	Menu.visible = false
