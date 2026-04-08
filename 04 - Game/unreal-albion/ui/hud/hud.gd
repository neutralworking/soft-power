extends VBoxContainer

var ego_bar: HBoxContainer
var creativity_bar: HBoxContainer
var attention_bar: HBoxContainer

const StatBarScene := preload("res://ui/hud/stat_bar.tscn")


func _ready() -> void:
	# Anchor top-left with 20px margin
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 0.0
	anchor_bottom = 0.0
	offset_left = 20
	offset_top = 20
	offset_right = 300
	offset_bottom = 120

	add_theme_constant_override("separation", 4)

	# Create stat bars
	ego_bar = StatBarScene.instantiate()
	ego_bar.name = "EgoBar"
	ego_bar.stat_name = "ego"
	add_child(ego_bar)

	creativity_bar = StatBarScene.instantiate()
	creativity_bar.name = "CreativityBar"
	creativity_bar.stat_name = "creativity"
	add_child(creativity_bar)

	attention_bar = StatBarScene.instantiate()
	attention_bar.name = "AttentionBar"
	attention_bar.stat_name = "attention"
	add_child(attention_bar)
