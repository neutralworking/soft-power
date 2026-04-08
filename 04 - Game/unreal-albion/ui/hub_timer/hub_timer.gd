extends HBoxContainer

var segments: Array = []


func _ready() -> void:
	set_anchors_preset(Control.PRESET_TOP_RIGHT)
	offset_left = -250
	offset_right = -20
	offset_top = 20
	add_theme_constant_override("separation", 8)

	var title := Label.new()
	title.text = "SET STARTS: "
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color("#8a8279"))
	add_child(title)

	for i in 3:
		var seg := ColorRect.new()
		seg.custom_minimum_size = Vector2(40, 16)
		seg.color = Color("#d4845a") if i < GameState.hub_segments_remaining else Color("#3a3530")
		add_child(seg)
		segments.append(seg)

	EventBus.hub_segment_consumed.connect(_on_segment_consumed)


func _on_segment_consumed() -> void:
	for i in segments.size():
		segments[i].color = Color("#d4845a") if i < GameState.hub_segments_remaining else Color("#3a3530")
