extends HBoxContainer

## The stat this bar tracks: "ego", "creativity", or "attention"
@export var stat_name: String = "ego"

const STAT_COLORS := {
	"ego": Color("#b43232"),
	"creativity": Color("#3264b4"),
	"attention": Color("#c8aa32"),
}

var icon_rect: TextureRect
var name_label: Label
var bar: ProgressBar
var value_label: Label


func _ready() -> void:
	# Build child nodes
	icon_rect = TextureRect.new()
	icon_rect.name = "Icon"
	icon_rect.custom_minimum_size = Vector2(32, 32)
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(icon_rect)

	name_label = Label.new()
	name_label.name = "Label"
	name_label.text = stat_name.capitalize()
	name_label.custom_minimum_size = Vector2(100, 0)
	name_label.add_theme_color_override("font_color", Color("#e0dbd4"))
	add_child(name_label)

	bar = ProgressBar.new()
	bar.name = "Bar"
	bar.custom_minimum_size = Vector2(150, 24)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.show_percentage = false
	add_child(bar)

	# Style the bar fill color
	var fill_style := StyleBoxFlat.new()
	var bar_color: Color = STAT_COLORS.get(stat_name, Color("#e0dbd4"))
	fill_style.bg_color = bar_color
	fill_style.corner_radius_top_left = 3
	fill_style.corner_radius_top_right = 3
	fill_style.corner_radius_bottom_left = 3
	fill_style.corner_radius_bottom_right = 3
	bar.add_theme_stylebox_override("fill", fill_style)

	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color("#3a3530")
	bg_style.corner_radius_top_left = 3
	bg_style.corner_radius_top_right = 3
	bg_style.corner_radius_bottom_left = 3
	bg_style.corner_radius_bottom_right = 3
	bar.add_theme_stylebox_override("background", bg_style)

	value_label = Label.new()
	value_label.name = "ValueLabel"
	value_label.custom_minimum_size = Vector2(50, 0)
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.add_theme_color_override("font_color", Color("#e0dbd4"))
	add_child(value_label)

	# Add spacing
	add_theme_constant_override("separation", 8)

	# Initialize with current values from GameState
	_update_display()

	# Connect to EventBus
	EventBus.stat_changed.connect(_on_stat_changed)


func _on_stat_changed(changed_stat: String, _old_value: int, _new_value: int) -> void:
	if changed_stat == stat_name:
		_update_display()


func _update_display() -> void:
	var current: int = GameState.get(stat_name)
	var max_val: int = GameState.get(stat_name + "_max")
	bar.max_value = max_val
	bar.value = current
	value_label.text = "%d/%d" % [current, max_val]
