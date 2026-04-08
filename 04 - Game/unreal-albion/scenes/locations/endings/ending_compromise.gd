extends Node2D

var lines: Array = [
	"Back corridor. Viv does not congratulate; they inventory.",
	"",
	"[color=#3c325a]\"Good. That can travel. We'll clean up the framing,",
	"obviously, but the core is there.\"[/color]",
	"",
	"Your phone buzzes with a calendar hold, a PDF,",
	"a contract-shaped tomorrow.",
	"",
	"[i]Congratulations arrives in the language of ownership.[/i]",
]
var current_line: int = 0
var label: RichTextLabel


func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#1a1815")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var ui := CanvasLayer.new()
	ui.layer = 10
	add_child(ui)

	label = RichTextLabel.new()
	label.bbcode_enabled = true
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.offset_left = 40
	label.offset_right = -40
	label.offset_top = 200
	label.offset_bottom = -100
	label.add_theme_font_size_override("normal_font_size", 32)
	label.add_theme_color_override("default_color", Color("#e0dbd4"))
	ui.add_child(label)

	_show_line()


func _show_line() -> void:
	if current_line < lines.size():
		label.append_text(lines[current_line] + "\n")
		current_line += 1
	else:
		label.append_text("\n[color=#8a8279][b]COMPROMISE[/b][/color]")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialogue"):
		_show_line()
