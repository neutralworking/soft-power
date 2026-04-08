extends Node

# Dialogue data
var dialogue_data: Dictionary = {}
var nodes_by_id: Dictionary = {}
var current_node_id: String = ""
var active_dialogue_id: String = ""

signal line_ready(line_data: Dictionary)
signal choices_ready(choices: Array)
signal dialogue_complete()


func start_dialogue(dialogue_id: String) -> void:
	var path := "res://data/dialogue/%s.json" % dialogue_id
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("DialogueManager: Could not open %s" % path)
		dialogue_complete.emit()
		return

	var json_text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var err := json.parse(json_text)
	if err != OK:
		push_error("DialogueManager: JSON parse error in %s: %s" % [path, json.get_error_message()])
		dialogue_complete.emit()
		return

	dialogue_data = json.data
	nodes_by_id.clear()

	for node in dialogue_data.get("nodes", []):
		nodes_by_id[node["id"]] = node

	active_dialogue_id = dialogue_id
	EventBus.dialogue_started.emit(dialogue_id)
	_go_to_node("start")


func _go_to_node(node_id: String) -> void:
	if not nodes_by_id.has(node_id):
		push_error("DialogueManager: Node '%s' not found in '%s'" % [node_id, active_dialogue_id])
		_end_dialogue()
		return

	current_node_id = node_id
	var node: Dictionary = nodes_by_id[node_id]

	# Check conditions on the node itself — skip if conditions fail
	if node.has("conditions") and not GameState.check_conditions(node["conditions"]):
		if node.has("next"):
			_go_to_node(node["next"])
		else:
			_end_dialogue()
		return

	match node.get("type", ""):
		"line":
			_process_line(node)
		"choice_set":
			_process_choice_set(node)
		"conditional_branch":
			_process_conditional_branch(node)
		"passive_insert":
			_process_passive_insert(node)
		"end":
			_process_end(node)
		_:
			push_error("DialogueManager: Unknown node type '%s'" % node.get("type", ""))
			_end_dialogue()


func _process_line(node: Dictionary) -> void:
	# Apply stat effects when the line displays
	if node.has("stat_effects"):
		GameState.apply_stat_effects(node["stat_effects"])

	# Set flags
	if node.has("set_flags"):
		for flag_name in node["set_flags"]:
			GameState.set_flag(flag_name, node["set_flags"][flag_name])

	line_ready.emit(node)


func _process_choice_set(node: Dictionary) -> void:
	var all_choices: Array = node.get("choices", [])
	var display_choices: Array = []

	for choice in all_choices:
		var available: bool = true
		if choice.has("conditions"):
			available = GameState.check_conditions(choice["conditions"])
		var affordable: bool = true
		if choice.has("costs"):
			affordable = GameState.can_afford(choice["costs"])

		var display := choice.duplicate(true)
		display["available"] = available
		display["affordable"] = affordable
		display["selectable"] = available and affordable
		display_choices.append(display)

	choices_ready.emit(display_choices)


func _process_conditional_branch(node: Dictionary) -> void:
	for branch in node.get("branches", []):
		var conditions: Array = branch.get("conditions", [])
		if conditions.is_empty() or GameState.check_conditions(conditions):
			_go_to_node(branch["next"])
			return
	# Fallthrough — no branch matched
	if node.has("next"):
		_go_to_node(node["next"])
	else:
		_end_dialogue()


func _process_passive_insert(node: Dictionary) -> void:
	var pool_name: String = node.get("pool", "")
	var inserts := _load_passive_inserts()
	var pool: Dictionary = inserts.get(pool_name, {})
	var highest_stat := GameState.get_highest_stat()
	var line_text: String = pool.get(highest_stat, "")

	if line_text != "":
		EventBus.passive_insert_triggered.emit(line_text)
		# Create a synthetic internal line node
		var synth_line := {
			"id": "passive_" + pool_name,
			"type": "line",
			"speaker": "ash",
			"text": line_text,
			"internal": true,
			"next": node.get("next", ""),
		}
		line_ready.emit(synth_line)
	else:
		# No insert available, skip to next
		if node.has("next"):
			_go_to_node(node["next"])
		else:
			_end_dialogue()


func _process_end(node: Dictionary) -> void:
	var trigger_scene: String = node.get("trigger_scene_change", "")
	_end_dialogue()
	if trigger_scene != "":
		EventBus.scene_change_requested.emit(trigger_scene)


func _end_dialogue() -> void:
	var id := active_dialogue_id
	active_dialogue_id = ""
	current_node_id = ""
	nodes_by_id.clear()
	dialogue_data.clear()
	EventBus.dialogue_ended.emit(id)
	dialogue_complete.emit()


# Called by UI when player advances past a line
func advance() -> void:
	if current_node_id == "":
		return
	var node: Dictionary = nodes_by_id.get(current_node_id, {})
	if node.has("next"):
		_go_to_node(node["next"])
	else:
		_end_dialogue()


# Called by UI when player selects a choice
func select_choice(choice_index: int) -> void:
	var node: Dictionary = nodes_by_id.get(current_node_id, {})
	var choices: Array = node.get("choices", [])
	if choice_index < 0 or choice_index >= choices.size():
		return

	var choice: Dictionary = choices[choice_index]

	# Apply costs
	if choice.has("costs"):
		GameState.apply_costs(choice["costs"])

	# Apply rewards
	if choice.has("rewards"):
		GameState.apply_rewards(choice["rewards"])

	# Set flags
	if choice.has("set_flags"):
		for flag_name in choice["set_flags"]:
			GameState.set_flag(flag_name, choice["set_flags"][flag_name])

	EventBus.choice_made.emit(choice.get("id", ""), choice)

	# Navigate to next node
	if choice.has("next"):
		_go_to_node(choice["next"])
	else:
		_end_dialogue()


# Load passive inserts from JSON
var _passive_inserts_cache: Dictionary = {}

func _load_passive_inserts() -> Dictionary:
	if not _passive_inserts_cache.is_empty():
		return _passive_inserts_cache

	var path := "res://data/passive_inserts.json"
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	var json := JSON.new()
	json.parse(file.get_as_text())
	file.close()
	_passive_inserts_cache = json.data if json.data is Dictionary else {}
	return _passive_inserts_cache
