extends Node

# === Stats ===
var ego: int = 5
var ego_max: int = 5
var creativity: int = 5
var creativity_max: int = 5
var attention: int = 2
var attention_max: int = 10
var room_heat: int = 0
const HEAT_OVERHEAT: int = 8

# === Branch flags (all from the production script) ===
var flags: Dictionary = {
	"prebuzz": false,
	"messaged_mara": false,
	"quiet_entry": false,
	"entered_flashy": false,
	"waited_outside": false,
	"jules_hostile": false,
	"jules_memory_softened": false,
	"jules_memory_token": false,
	"viv_package_flag": false,
	"viv_interested": false,
	"accepted_token": false,
	"bootsy_support": false,
	"bootsy_soft_intro": false,
	"warned": false,
	"grounded": false,
	"vulnerable": false,
	"killer_opening": false,
	"viv_exposed": false,
}

# === Hub state ===
var hub_segments_remaining: int = 3
var conversations_completed: Array[String] = []

# === Combat state ===
var current_round: int = 0
var combat_active: bool = false
var overheat_triggered: bool = false
var crowd_bias: int = 0
var call_out_locked: bool = false


func _ready() -> void:
	EventBus.scene_change_requested.connect(_on_scene_change)


func _on_scene_change(_scene_id: String) -> void:
	call_out_locked = false


# --- Stat methods ---

func modify_stat(stat_name: String, delta: int) -> void:
	var old_value: int = get(stat_name)
	var max_key: String = stat_name + "_max"
	var max_val: int = get(max_key) if max_key in ["ego_max", "creativity_max", "attention_max"] else 999

	if stat_name == "room_heat":
		max_val = HEAT_OVERHEAT

	var new_value: int = clampi(old_value + delta, 0, max_val)
	set(stat_name, new_value)

	if stat_name == "room_heat":
		EventBus.heat_changed.emit(old_value, new_value)
		if new_value >= HEAT_OVERHEAT and not overheat_triggered:
			overheat_triggered = true
			EventBus.heat_overheat.emit()
	else:
		EventBus.stat_changed.emit(stat_name, old_value, new_value)
		if stat_name == "ego" and new_value <= 0:
			EventBus.ego_zero.emit()


func set_flag(flag_name: String, value: bool = true) -> void:
	flags[flag_name] = value
	EventBus.flag_set.emit(flag_name, value)


func get_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)


func check_condition(condition: Dictionary) -> bool:
	if condition.has("flag"):
		return get_flag(condition["flag"]) == condition.get("value", true)
	if condition.has("stat"):
		var stat_val: int = get(condition["stat"])
		if condition.has("min") and stat_val < condition["min"]:
			return false
		if condition.has("max") and stat_val > condition["max"]:
			return false
		return true
	if condition.has("conversations_completed_count"):
		var req: Dictionary = condition["conversations_completed_count"]
		var count: int = conversations_completed.size()
		if req.has("min") and count < req["min"]:
			return false
		return true
	return true


func check_conditions(conditions: Array) -> bool:
	for cond in conditions:
		if not check_condition(cond):
			return false
	return true


func can_afford(costs: Dictionary) -> bool:
	for stat_name in costs:
		if get(stat_name) < costs[stat_name]:
			return false
	return true


func apply_costs(costs: Dictionary) -> void:
	for stat_name in costs:
		modify_stat(stat_name, -costs[stat_name])


func apply_rewards(rewards: Dictionary) -> void:
	for stat_name in rewards:
		modify_stat(stat_name, rewards[stat_name])


func apply_stat_effects(effects: Dictionary) -> void:
	for stat_name in effects:
		modify_stat(stat_name, effects[stat_name])


func get_highest_stat() -> String:
	var stats := {"ego": ego, "creativity": creativity, "attention": attention}
	var highest_name := "ego"
	var highest_val := ego
	for s in stats:
		if stats[s] > highest_val:
			highest_val = stats[s]
			highest_name = s
	return highest_name


func consume_hub_segment() -> void:
	hub_segments_remaining -= 1
	EventBus.hub_segment_consumed.emit()
	if hub_segments_remaining <= 0:
		EventBus.hub_timer_expired.emit()


func get_ending() -> String:
	if ego <= 0:
		return "ending_fold"
	if get_flag("accepted_token") and not get_flag("viv_exposed"):
		return "ending_compromise"
	return "ending_breakthrough"


func reset() -> void:
	ego = 5
	ego_max = 5
	creativity = 5
	creativity_max = 5
	attention = 2
	attention_max = 10
	room_heat = 0
	overheat_triggered = false
	crowd_bias = 0
	call_out_locked = false
	current_round = 0
	combat_active = false
	hub_segments_remaining = 3
	conversations_completed.clear()
	for key in flags:
		flags[key] = false
