extends PanelContainer

var messages: Array = []
var message_container: VBoxContainer
var is_open: bool = false


func _ready() -> void:
	visible = false
	# Full-screen overlay for mobile portrait
	set_anchors_preset(Control.PRESET_FULL_RECT)
	offset_left = 24
	offset_right = -24
	offset_top = 200
	offset_bottom = -24

	var style := StyleBoxFlat.new()
	style.bg_color = Color("#1a1815e6")
	style.border_color = Color("#3a3530")
	style.set_border_width_all(2)
	style.set_corner_radius_all(12)
	add_theme_stylebox_override("panel", style)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	var title_row := HBoxContainer.new()
	title_row.add_theme_constant_override("separation", 12)
	vbox.add_child(title_row)

	var title := Label.new()
	title.text = "MESSAGES"
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color("#d4845a"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_row.add_child(title)

	var close_btn := Button.new()
	close_btn.text = "X"
	close_btn.add_theme_font_size_override("font_size", 28)
	close_btn.custom_minimum_size = Vector2(56, 56)
	close_btn.pressed.connect(toggle)
	title_row.add_child(close_btn)

	var sep := HSeparator.new()
	sep.add_theme_color_override("separator", Color("#3a3530"))
	vbox.add_child(sep)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(scroll)

	message_container = VBoxContainer.new()
	message_container.add_theme_constant_override("separation", 12)
	scroll.add_child(message_container)

	EventBus.phone_message_received.connect(_on_message_received)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_phone"):
		toggle()


func toggle() -> void:
	is_open = not is_open
	visible = is_open
	if is_open:
		EventBus.phone_opened.emit()
	else:
		EventBus.phone_closed.emit()


func _on_message_received(msg_data: Dictionary) -> void:
	messages.append(msg_data)
	_add_message_display(msg_data)


func _add_message_display(msg: Dictionary) -> void:
	var item := VBoxContainer.new()
	item.add_theme_constant_override("separation", 4)

	var sender := Label.new()
	sender.text = msg.get("sender", "Unknown")
	sender.add_theme_font_size_override("font_size", 24)
	sender.add_theme_color_override("font_color", Color("#d4845a"))
	item.add_child(sender)

	var text := Label.new()
	text.text = msg.get("text", "")
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size", 26)
	text.add_theme_color_override("font_color", Color("#e0dbd4"))
	item.add_child(text)

	if msg.has("attention_cost"):
		var cost := Label.new()
		cost.text = "ATTENTION +%d" % msg["attention_cost"]
		cost.add_theme_font_size_override("font_size", 20)
		cost.add_theme_color_override("font_color", Color("#c8aa32"))
		item.add_child(cost)

	message_container.add_child(item)
