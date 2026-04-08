extends Node2D

var lines: Array = [
	"The set ends in a strange, electric quiet before applause arrives.",
	"Not unanimous. Better than unanimous. Real.",
	"",
	"Outside, air hits cold. Your phone lights up:",
	"  Unknown promoter: \"You free Saturday?\"",
	"  Friend: \"Okay that was disgusting in the best way\"",
	"",
	"[i]The room says your name like it has found a use for it.[/i]",
	"[i]You leave before it can decide the price.[/i]",
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
		label.append_text("\n[color=#d4845a][b]BREAKTHROUGH[/b][/color]")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialogue"):
		_show_line()
