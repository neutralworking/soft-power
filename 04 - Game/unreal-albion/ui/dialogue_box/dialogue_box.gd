extends PanelContainer

const ChoiceButtonScene := preload("res://ui/dialogue_box/choice_button.tscn")

const COLOR_BG := Color("#1a1815")
const COLOR_TEXT := Color("#e0dbd4")
const COLOR_MUTED := Color("#8a8279")
const COLOR_ACCENT := Color("#d4845a")

const TYPEWRITER_SPEED := 0.03  # seconds per character

var margin_container: MarginContainer
var vbox: VBoxContainer
var top_row: HBoxContainer
var speaker_name: Label
var text_display: RichTextLabel
var choice_container: VBoxContainer

var _typewriter_active: bool = false
var _full_text: String = ""
var _visible_chars: int = 0
var _dialogue_active: bool = false
var _showing_choices: bool = false
var _typewriter_tween: Tween


func _ready() -> void:
	# Anchor to bottom of screen, full width
	anchor_left = 0.0
	anchor_top = 1.0
	anchor_right = 1.0
	anchor_bottom = 1.0
	offset_top = -250
	offset_left = 0
	offset_right = 0
	offset_bottom = 0

	# Panel background with 80% opacity
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(COLOR_BG.r, COLOR_BG.g, COLOR_BG.b, 0.8)
	panel_style.border_color = Color("#3a3530")
	panel_style.border_width_top = 2
	add_theme_stylebox_override("panel", panel_style)

	# MarginContainer
	margin_container = MarginContainer.new()
	margin_container.name = "MarginContainer"
	margin_container.add_theme_constant_override("margin_left", 20)
	margin_container.add_theme_constant_override("margin_right", 20)
	margin_container.add_theme_constant_override("margin_top", 20)
	margin_container.add_theme_constant_override("margin_bottom", 20)
	add_child(margin_container)

	# VBox layout
	vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.add_theme_constant_override("separation", 12)
	margin_container.add_child(vbox)

	# Top row with speaker name
	top_row = HBoxContainer.new()
	top_row.name = "TopRow"
	vbox.add_child(top_row)

	speaker_name = Label.new()
	speaker_name.name = "SpeakerName"
	speaker_name.add_theme_color_override("font_color", COLOR_ACCENT)
	speaker_name.add_theme_font_size_override("font_size", 20)
	top_row.add_child(speaker_name)

	# Text display
	text_display = RichTextLabel.new()
	text_display.name = "TextDisplay"
	text_display.bbcode_enabled = true
	text_display.fit_content = true
	text_display.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_display.scroll_active = false
	text_display.add_theme_color_override("default_color", COLOR_TEXT)
	text_display.add_theme_font_size_override("normal_font_size", 18)
	vbox.add_child(text_display)

	# Choice container
	choice_container = VBoxContainer.new()
	choice_container.name = "ChoiceContainer"
	choice_container.add_theme_constant_override("separation", 6)
	choice_container.visible = false
	vbox.add_child(choice_container)

	# Connect to DialogueManager signals
	DialogueManager.line_ready.connect(_on_line_ready)
	DialogueManager.choices_ready.connect(_on_choices_ready)
	DialogueManager.dialogue_complete.connect(_on_dialogue_complete)

	# Start hidden
	visible = false


func _input(event: InputEvent) -> void:
	if not _dialogue_active:
		return
	if _showing_choices:
		return
	if event.is_action_pressed("advance_dialogue"):
		get_viewport().set_input_as_handled()
		if _typewriter_active:
			# Skip to end of typewriter
			_finish_typewriter()
		else:
			# Advance to next line
			DialogueManager.advance()


func _on_line_ready(line_data: Dictionary) -> void:
	_dialogue_active = true
	_showing_choices = false
	visible = true
	choice_container.visible = false

	# Clear old choices
	_clear_choices()

	# Set speaker
	var speaker: String = line_data.get("speaker", "")
	if speaker != "":
		speaker_name.text = speaker.to_upper()
		speaker_name.visible = true
	else:
		speaker_name.visible = false

	# Determine text and styling
	var line_text: String = line_data.get("text", "")
	var is_internal: bool = line_data.get("internal", false)

	if is_internal:
		# Internal thoughts: italic, muted color
		_full_text = "[color=#%s][i]%s[/i][/color]" % [COLOR_MUTED.to_html(false), line_text]
	else:
		_full_text = line_text

	# Start typewriter effect
	_start_typewriter()


func _on_choices_ready(choices: Array) -> void:
	_dialogue_active = true
	_showing_choices = true
	visible = true
	choice_container.visible = true

	_clear_choices()

	for i in choices.size():
		var choice: Dictionary = choices[i]
		var button: PanelContainer = ChoiceButtonScene.instantiate()
		choice_container.add_child(button)
		button.setup(choice, i)
		button.choice_selected.connect(_on_choice_selected)


func _on_choice_selected(index: int) -> void:
	_showing_choices = false
	DialogueManager.select_choice(index)


func _on_dialogue_complete() -> void:
	_dialogue_active = false
	_showing_choices = false
	_stop_typewriter()
	visible = false


func _start_typewriter() -> void:
	text_display.text = _full_text
	text_display.visible_characters = 0
	_visible_chars = 0
	_typewriter_active = true

	var total_chars := text_display.get_total_character_count()
	if total_chars <= 0:
		_finish_typewriter()
		return

	# Kill previous tween if still running
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()

	_typewriter_tween = create_tween()
	_typewriter_tween.tween_property(text_display, "visible_characters", total_chars, total_chars * TYPEWRITER_SPEED)
	_typewriter_tween.finished.connect(_on_typewriter_finished)


func _finish_typewriter() -> void:
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()
	text_display.visible_characters = -1  # Show all
	_typewriter_active = false


func _stop_typewriter() -> void:
	if _typewriter_tween and _typewriter_tween.is_valid():
		_typewriter_tween.kill()
	_typewriter_active = false


func _on_typewriter_finished() -> void:
	_typewriter_active = false


func _clear_choices() -> void:
	for child in choice_container.get_children():
		child.queue_free()
