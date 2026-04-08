extends PanelContainer

signal choice_selected(index: int)

var choice_data: Dictionary = {}
var choice_index: int = 0
var selectable: bool = true

var hbox: HBoxContainer
var choice_text: Label
var cost_tag: Label
var lock_hint: Label

const COLOR_AVAILABLE := Color("#e0dbd4")
const COLOR_LOCKED := Color("#4a4540")
const COLOR_ACCENT := Color("#d4845a")
const COLOR_BG := Color("#1a1815")


func _ready() -> void:
	# Background style
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color("#2a2520")
	panel_style.corner_radius_top_left = 4
	panel_style.corner_radius_top_right = 4
	panel_style.corner_radius_bottom_left = 4
	panel_style.corner_radius_bottom_right = 4
	panel_style.content_margin_left = 16
	panel_style.content_margin_right = 16
	panel_style.content_margin_top = 14
	panel_style.content_margin_bottom = 14
	add_theme_stylebox_override("panel", panel_style)

	hbox = HBoxContainer.new()
	hbox.name = "HBox"
	hbox.add_theme_constant_override("separation", 12)
	add_child(hbox)

	choice_text = Label.new()
	choice_text.name = "ChoiceText"
	choice_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	choice_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	choice_text.add_theme_font_size_override("font_size", 26)
	hbox.add_child(choice_text)

	cost_tag = Label.new()
	cost_tag.name = "CostTag"
	cost_tag.add_theme_color_override("font_color", COLOR_ACCENT)
	cost_tag.add_theme_font_size_override("font_size", 22)
	cost_tag.visible = false
	hbox.add_child(cost_tag)

	lock_hint = Label.new()
	lock_hint.name = "LockHint"
	lock_hint.add_theme_color_override("font_color", COLOR_LOCKED)
	lock_hint.add_theme_font_size_override("font_size", 20)
	lock_hint.visible = false
	hbox.add_child(lock_hint)

	# Apply choice data if already set
	_apply_data()

	# Handle mouse input
	mouse_filter = Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func setup(data: Dictionary, index: int) -> void:
	choice_data = data
	choice_index = index
	selectable = data.get("selectable", true)
	_apply_data()


func _apply_data() -> void:
	if not is_inside_tree():
		return

	choice_text.text = choice_data.get("text", "")

	# Show cost tag if there are costs
	var costs: Dictionary = choice_data.get("costs", {})
	if not costs.is_empty():
		var cost_parts: Array[String] = []
		for stat in costs:
			cost_parts.append("-%d %s" % [costs[stat], stat.capitalize()])
		cost_tag.text = ", ".join(cost_parts)
		cost_tag.visible = true
	else:
		cost_tag.visible = false

	# Show lock hint if not available (condition failed, not just cost)
	if not choice_data.get("available", true):
		var conditions: Array = choice_data.get("conditions", [])
		var hints: Array[String] = []
		for cond in conditions:
			if cond.has("flag"):
				hints.append(cond["flag"])
		if hints.is_empty():
			lock_hint.text = "[Locked]"
		else:
			lock_hint.text = "[Requires: %s]" % ", ".join(hints)
		lock_hint.visible = true
	else:
		lock_hint.visible = false

	# Dim if not selectable
	if selectable:
		choice_text.add_theme_color_override("font_color", COLOR_AVAILABLE)
		modulate.a = 1.0
	else:
		choice_text.add_theme_color_override("font_color", COLOR_LOCKED)
		modulate.a = 0.5


func _on_gui_input(event: InputEvent) -> void:
	if not selectable:
		return
	# Support both mouse click and touch
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		choice_selected.emit(choice_index)
	elif event is InputEventScreenTouch and event.pressed:
		choice_selected.emit(choice_index)


func _on_mouse_entered() -> void:
	if selectable:
		modulate = Color(1.2, 1.2, 1.2, 1.0)


func _on_mouse_exited() -> void:
	if selectable:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		modulate.a = 0.5
