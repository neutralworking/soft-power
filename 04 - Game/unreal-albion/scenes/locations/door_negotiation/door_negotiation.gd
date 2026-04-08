extends Node2D


func _ready() -> void:
	# Background
	var bg := TextureRect.new()
	bg.name = "Background"
	bg.texture = load("res://assets/backgrounds/albion_exterior.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.anchors_preset = Control.PRESET_FULL_RECT
	add_child(bg)

	# Start the scene dialogue
	DialogueManager.start_dialogue("scene_2_door_negotiation")
