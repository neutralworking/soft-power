extends Node2D

var lines: Array = [
	"No dramatic collapse. No one calls an ambulance.",
	"Mara is already resetting the room.",
	"",
	"Someone from Viv's orbit hands you water and says,",
	"very gently, \"You did the smart thing.\"",
	"",
	"A path opens. Manageable work. Sharper clothes.",
	"Fewer dangerous edges. A safer self with better admin.",
	"",
	"[i]By midnight, everyone agrees you finally seem serious.[/i]",
]
var current_line: int = 0
var label: RichTextLabel


func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#0f0e0c")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var ui := CanvasLayer.new()
	ui.layer = 10
	add_child(ui)

	label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.offset_left = -500
	label.offset_right = 500
	label.offset_top = -200
	label.offset_bottom = 200
	label.add_theme_font_size_override("normal_font_size", 26)
	label.add_theme_color_override("default_color", Color("#8a8279"))
	ui.add_child(label)

	_show_line()


func _show_line() -> void:
	if current_line < lines.size():
		label.append_text(lines[current_line] + "\n")
		current_line += 1
	else:
		label.append_text("\n[color=#b43232][b]FOLD[/b][/color]")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialogue"):
		_show_line()
