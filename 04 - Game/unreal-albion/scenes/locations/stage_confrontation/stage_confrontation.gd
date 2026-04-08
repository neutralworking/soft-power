extends Node2D

enum CombatState { ROUND_START, PLAYER_TURN, ENEMY_TURN, ROUND_END, COMBAT_OVER }

var state: CombatState = CombatState.ROUND_START
var round_num: int = 0
var deflect_active: bool = false
var viv_data: Dictionary = {}
var jules_data: Dictionary = {}
var viv_ego: int = 6
var jules_ego: int = 5

# UI references
var heat_label: Label
var round_label: Label
var info_label: RichTextLabel
var action_buttons: Dictionary = {}
var btn_container: VBoxContainer


func _ready() -> void:
	# Background
	var bg := TextureRect.new()
	bg.texture = load("res://assets/backgrounds/albion_stage.png")
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Load enemy data
	viv_data = _load_json("res://data/enemies/viv_kane.json")
	jules_data = _load_json("res://data/enemies/jules_rook.json")

	# Build UI
	var ui := CanvasLayer.new()
	ui.layer = 15
	add_child(ui)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#1a1815c0")
	panel.add_theme_stylebox_override("panel", style)
	ui.add_child(panel)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 60)
	margin.add_theme_constant_override("margin_right", 60)
	margin.add_theme_constant_override("margin_top", 40)
	margin.add_theme_constant_override("margin_bottom", 40)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)

	# Top row: Round + Heat
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 40)
	vbox.add_child(top)

	round_label = Label.new()
	round_label.text = "ROUND 1"
	round_label.add_theme_font_size_override("font_size", 28)
	round_label.add_theme_color_override("font_color", Color("#e0dbd4"))
	top.add_child(round_label)

	heat_label = Label.new()
	heat_label.text = "HEAT: 0 / 8"
	heat_label.add_theme_font_size_override("font_size", 28)
	heat_label.add_theme_color_override("font_color", Color("#c85020"))
	top.add_child(heat_label)

	var enemy_label := Label.new()
	enemy_label.text = "VS: Viv Kane (Ego:%d) | Jules Rook (Ego:%d)" % [viv_ego, jules_ego]
	enemy_label.name = "EnemyLabel"
	enemy_label.add_theme_font_size_override("font_size", 22)
	enemy_label.add_theme_color_override("font_color", Color("#d4845a"))
	top.add_child(enemy_label)

	# Info display
	info_label = RichTextLabel.new()
	info_label.bbcode_enabled = true
	info_label.fit_content = true
	info_label.custom_minimum_size = Vector2(0, 300)
	info_label.add_theme_font_size_override("normal_font_size", 20)
	info_label.add_theme_color_override("default_color", Color("#e0dbd4"))
	vbox.add_child(info_label)

	# Action buttons
	btn_container = VBoxContainer.new()
	btn_container.add_theme_constant_override("separation", 8)
	vbox.add_child(btn_container)

	var actions := ["PERFORM", "CONFESS", "CALL OUT", "DEFLECT", "GROUND"]
	var costs := ["2 Creativity", "1 Creativity", "3+ Attention", "1 Creativity", "Free"]
	for i in actions.size():
		var btn := Button.new()
		btn.text = "%s  [%s]" % [actions[i], costs[i]]
		btn.add_theme_font_size_override("font_size", 20)
		btn.pressed.connect(_on_action.bind(actions[i]))
		btn_container.add_child(btn)
		action_buttons[actions[i]] = btn

	GameState.combat_active = true
	GameState.current_round = 0

	# Apply entry variants
	if GameState.get_flag("entered_flashy"):
		GameState.modify_stat("room_heat", 1)
	if GameState.get_flag("killer_opening"):
		_log("[color=#c8aa32]Your rewritten opener cuts through the noise.[/color]")

	EventBus.combat_started.emit()
	_start_round()


func _start_round() -> void:
	round_num += 1
	GameState.current_round = round_num
	state = CombatState.ROUND_START
	round_label.text = "ROUND %d" % round_num
	deflect_active = false
	GameState.call_out_locked = false

	EventBus.combat_round_started.emit(round_num)

	if round_num > 1:
		# Passive insert
		var inserts := _load_json("res://data/passive_inserts.json")
		var pool_key := "stage_round_%d" % round_num
		var pool: Dictionary = inserts.get(pool_key, {})
		var highest := GameState.get_highest_stat()
		var insert_text: String = pool.get(highest, "")
		if insert_text != "":
			_log("[i][color=#8a8279]%s[/color][/i]" % insert_text)

	_log("\n[color=#d4845a]— Round %d —[/color]" % round_num)
	_update_ui()
	state = CombatState.PLAYER_TURN
	_enable_actions(true)


func _on_action(action: String) -> void:
	if state != CombatState.PLAYER_TURN:
		return
	_enable_actions(false)

	var overheat_bonus: int = 1 if GameState.overheat_triggered else 0

	match action:
		"PERFORM":
			if not GameState.can_afford({"creativity": 2}):
				_log("[color=#b43232]Not enough Creativity.[/color]")
				_enable_actions(true)
				return
			GameState.apply_costs({"creativity": 2})
			var dmg := 2 + overheat_bonus
			viv_ego = maxi(viv_ego - dmg, 0)
			GameState.modify_stat("attention", 1)
			GameState.modify_stat("room_heat", 1)
			_log("Ash [b]PERFORMS[/b]. Viv takes %d Ego damage. Attention +1. Heat +1." % dmg)

		"CONFESS":
			if not GameState.can_afford({"creativity": 1}):
				_log("[color=#b43232]Not enough Creativity.[/color]")
				_enable_actions(true)
				return
			GameState.apply_costs({"creativity": 1})
			GameState.modify_stat("ego", 1)
			_log("Ash [b]CONFESSES[/b]. Ego restored +1.")
			if GameState.get_flag("jules_memory_softened"):
				jules_ego = maxi(jules_ego - 1, 0)
				_log("Jules falters. Jules Ego -1.")

		"CALL OUT":
			if GameState.call_out_locked:
				_log("[color=#b43232]CALL OUT is locked this round.[/color]")
				_enable_actions(true)
				return
			if GameState.attention < 3:
				_log("[color=#b43232]Need 3+ Attention to Call Out.[/color]")
				_enable_actions(true)
				return
			var dmg := 3 + overheat_bonus
			viv_ego = maxi(viv_ego - dmg, 0)
			GameState.modify_stat("room_heat", 2)
			if GameState.get_flag("viv_interested"):
				GameState.set_flag("viv_exposed")
				_log("Ash [b]CALLS OUT[/b] Viv. [color=#c8aa32]VIV EXPOSED.[/color] %d Ego damage." % dmg)
			else:
				_log("Ash [b]CALLS OUT[/b] Viv. %d Ego damage. Heat +2." % dmg)

		"DEFLECT":
			if not GameState.can_afford({"creativity": 1}):
				_log("[color=#b43232]Not enough Creativity.[/color]")
				_enable_actions(true)
				return
			GameState.apply_costs({"creativity": 1})
			deflect_active = true
			_log("Ash [b]DEFLECTS[/b]. Next enemy rider effect will be negated.")

		"GROUND":
			GameState.modify_stat("room_heat", -1)
			GameState.modify_stat("ego", 1)
			_log("Ash [b]GROUNDS[/b]. Ego +1, Heat -1.")

	_update_ui()
	state = CombatState.ENEMY_TURN
	await get_tree().create_timer(0.8).timeout
	_enemy_turn()


func _enemy_turn() -> void:
	var overheat_bonus: int = 1 if GameState.overheat_triggered else 0

	# Viv acts
	if viv_ego > 0:
		if GameState.attention >= 5 or GameState.get_flag("viv_interested"):
			# Package You
			var ego_dmg := 1 + overheat_bonus
			var attn_steal := 2
			_log("\n[color=#3c325a]Viv uses [b]Package You[/b].[/color] \"%s\"" % viv_data.get("signature_move", {}).get("line", ""))
			GameState.modify_stat("ego", -ego_dmg)
			GameState.modify_stat("attention", -attn_steal)
			if not deflect_active:
				GameState.call_out_locked = true
				_log("[color=#8a8279]CALL OUT locked next round.[/color]")
			else:
				_log("[color=#5a9a5a]Deflected! Lock negated.[/color]")
		else:
			var ego_dmg := 1 + overheat_bonus
			_log("\n[color=#3c325a]Viv: [b]Market Research[/b].[/color] \"%s\"" % viv_data.get("basic_attack", {}).get("line", ""))
			GameState.modify_stat("ego", -ego_dmg)

	# Jules acts
	if jules_ego > 0:
		if GameState.get_flag("jules_memory_token"):
			var ego_dmg := 2 + overheat_bonus
			if deflect_active:
				ego_dmg = maxi(ego_dmg - 1, 1)
				_log("[color=#5a9a5a]Deflected! Reduced damage.[/color]")
			_log("[color=#324632]Jules uses [b]You Used To[/b].[/color] \"%s\"" % jules_data.get("signature_move", {}).get("line", ""))
			GameState.modify_stat("ego", -ego_dmg)
		else:
			var ego_dmg := 1 + overheat_bonus
			_log("[color=#324632]Jules: [b]Old Wounds[/b].[/color] \"%s\"" % jules_data.get("basic_attack", {}).get("line", ""))
			GameState.modify_stat("ego", -ego_dmg)

	deflect_active = false
	_update_ui()
	state = CombatState.ROUND_END
	await get_tree().create_timer(0.8).timeout
	_check_round_end()


func _check_round_end() -> void:
	# Check fold
	if GameState.ego <= 0:
		_end_combat()
		return

	# Check overheat
	if GameState.room_heat >= GameState.HEAT_OVERHEAT and not GameState.overheat_triggered:
		GameState.overheat_triggered = true
		_log("\n[color=#c85020][b]OVERHEAT![/b] The room tips. Phones rise. Every sound now has consequences.[/color]")

	# Round 3 complete
	if round_num >= 3:
		_end_combat()
		return

	EventBus.combat_round_ended.emit(round_num)
	_start_round()


func _end_combat() -> void:
	state = CombatState.COMBAT_OVER
	GameState.combat_active = false
	_enable_actions(false)

	if GameState.ego <= 0:
		_log("\n[color=#b43232][b]You fold.[/b][/color]")
	elif GameState.get_flag("accepted_token") and not GameState.get_flag("viv_exposed"):
		_log("\n[color=#8a8279]The deal is done.[/color]")
	else:
		_log("\n[color=#c8aa32][b]You survived.[/b][/color]")

	EventBus.combat_ended.emit(GameState.get_ending())
	await get_tree().create_timer(2.0).timeout
	SceneManager.go_to_ending()


func _enable_actions(enabled: bool) -> void:
	for key in action_buttons:
		var btn: Button = action_buttons[key]
		btn.disabled = not enabled
		if enabled:
			# Specific availability checks
			match key:
				"PERFORM":
					btn.disabled = GameState.creativity < 2
				"CONFESS":
					btn.disabled = GameState.creativity < 1
				"CALL OUT":
					btn.disabled = GameState.attention < 3 or GameState.call_out_locked
				"DEFLECT":
					btn.disabled = GameState.creativity < 1
				"GROUND":
					btn.disabled = false


func _update_ui() -> void:
	heat_label.text = "HEAT: %d / %d" % [GameState.room_heat, GameState.HEAT_OVERHEAT]
	if GameState.room_heat >= 6:
		heat_label.add_theme_color_override("font_color", Color("#ff3030"))
	var enemy_label := get_node_or_null("EnemyLabel")
	# Update enemy display through the tree
	for child in get_tree().get_nodes_in_group(""):
		pass
	# Just find it in the UI
	var top_nodes = heat_label.get_parent().get_children()
	for n in top_nodes:
		if n.name == "EnemyLabel":
			n.text = "VS: Viv Kane (Ego:%d) | Jules Rook (Ego:%d)" % [viv_ego, jules_ego]


func _log(text: String) -> void:
	info_label.append_text(text + "\n")
	# Auto-scroll
	info_label.scroll_to_line(info_label.get_line_count())


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	var json := JSON.new()
	json.parse(file.get_as_text())
	file.close()
	return json.data if json.data is Dictionary else {}
