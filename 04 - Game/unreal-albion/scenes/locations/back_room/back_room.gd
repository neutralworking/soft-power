extends Node2D


func _ready() -> void:
	# Background
	var bg := TextureRect.new()
	bg.name = "Background"
	bg.texture = load("res://assets/backgrounds/albion_back_room.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.anchors_preset = Control.PRESET_FULL_RECT
	add_child(bg)

	# Start the scene dialogue — the dialogue JSON handles recovery choices
	# and transitions to stage_confrontation
	DialogueManager.start_dialogue("scene_4_back_room")
