extends TextureRect


func _ready() -> void:
	# 300x450, anchored to left side
	custom_minimum_size = Vector2(300, 450)
	anchor_left = 0.0
	anchor_top = 0.5
	anchor_right = 0.0
	anchor_bottom = 0.5
	offset_left = 20
	offset_top = -225
	offset_right = 320
	offset_bottom = 225
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false


func set_character(char_name: String, mood: String = "neutral") -> void:
	var path := "res://assets/portraits/%s.png" % char_name
	if ResourceLoader.exists(path):
		texture = load(path)
		visible = true
	else:
		push_warning("Portrait: No portrait found at %s" % path)
		texture = null
		visible = false


func clear_portrait() -> void:
	texture = null
	visible = false
