extends Node2D

# NPC tracking
var visited_npcs: Dictionary = {}
var npc_buttons: Dictionary = {}

# NPC definitions: id -> { label, dialogue_id, x_ratio }
const NPC_DATA: Array = [
	{ "id": "jules", "label": "JULES", "dialogue_id": "scene_3_jules_conversation", "x_ratio": 0.17 },
	{ "id": "viv", "label": "VIV", "dialogue_id": "scene_3_viv_conversation", "x_ratio": 0.50 },
	{ "id": "bootsy", "label": "BOOTSY", "dialogue_id": "scene_3_bootsy_conversation", "x_ratio": 0.83 },
]


func _ready() -> void:
	# Background
	var bg := TextureRect.new()
	bg.name = "Background"
	bg.texture = load("res://assets/backgrounds/albion_main_room.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.anchors_preset = Control.PRESET_FULL_RECT
	add_child(bg)

	# If the player waited outside, they have fewer hub segments
	if GameState.get_flag("waited_outside"):
		GameState.hub_segments_remaining = 2

	# Build NPC interaction buttons
	_build_npc_buttons()

	# Connect signals
	EventBus.dialogue_ended.connect(_on_dialogue_ended)
	EventBus.hub_timer_expired.connect(_on_hub_timer_expired)


func _build_npc_buttons() -> void:
	var viewport_size := Vector2(1280, 720)

	for npc in NPC_DATA:
		var btn := Button.new()
		btn.name = "NPC_" + npc["id"]
		btn.text = npc["label"]
		btn.custom_minimum_size = Vector2(160, 60)

		# Position: spread across the screen horizontally, centered vertically
		var x_pos: float = viewport_size.x * npc["x_ratio"] - 80.0
		var y_pos: float = viewport_size.y * 0.6
		btn.position = Vector2(x_pos, y_pos)

		# Style
		btn.add_theme_font_size_override("font_size", 20)

		# Connect press signal — bind the npc id
		btn.pressed.connect(_on_npc_pressed.bind(npc["id"]))

		add_child(btn)
		npc_buttons[npc["id"]] = btn

		# Initialize visited tracking
		visited_npcs[npc["id"]] = false


func _on_npc_pressed(npc_id: String) -> void:
	# Prevent interaction if already visited
	if visited_npcs[npc_id]:
		return

	# Mark as visited and grey out the button
	visited_npcs[npc_id] = true
	var btn: Button = npc_buttons[npc_id]
	btn.disabled = true

	# Record in GameState
	if npc_id not in GameState.conversations_completed:
		GameState.conversations_completed.append(npc_id)

	# Consume a hub segment
	GameState.consume_hub_segment()

	# Disable all NPC buttons while in conversation
	_set_all_buttons_disabled(true)

	# Start the NPC dialogue
	var dialogue_id := ""
	for npc in NPC_DATA:
		if npc["id"] == npc_id:
			dialogue_id = npc["dialogue_id"]
			break

	EventBus.npc_interaction_started.emit(npc_id)
	DialogueManager.start_dialogue(dialogue_id)


func _on_dialogue_ended(_dialogue_id: String) -> void:
	# Re-enable unvisited NPC buttons
	_set_all_buttons_disabled(false)
	_update_button_states()

	# Check if we should transition — 2 conversations done means
	# hub_segments_remaining <= 1 (started at 3, consumed 2)
	var conversations_done: int = 0
	for npc_id in visited_npcs:
		if visited_npcs[npc_id]:
			conversations_done += 1

	if conversations_done >= 2:
		_transition_to_back_room()


func _on_hub_timer_expired() -> void:
	# Force transition when hub time runs out
	_transition_to_back_room()


func _transition_to_back_room() -> void:
	# Disconnect signals to prevent double-firing
	if EventBus.dialogue_ended.is_connected(_on_dialogue_ended):
		EventBus.dialogue_ended.disconnect(_on_dialogue_ended)
	if EventBus.hub_timer_expired.is_connected(_on_hub_timer_expired):
		EventBus.hub_timer_expired.disconnect(_on_hub_timer_expired)

	SceneManager.change_scene("back_room")


func _set_all_buttons_disabled(disabled: bool) -> void:
	for npc_id in npc_buttons:
		npc_buttons[npc_id].disabled = disabled if not visited_npcs[npc_id] else true


func _update_button_states() -> void:
	for npc_id in npc_buttons:
		var btn: Button = npc_buttons[npc_id]
		btn.disabled = visited_npcs[npc_id]
		if visited_npcs[npc_id]:
			btn.modulate = Color(0.5, 0.5, 0.5, 0.7)
