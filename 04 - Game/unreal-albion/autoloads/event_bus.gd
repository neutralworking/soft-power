extends Node

# === Stat signals ===
signal stat_changed(stat_name: String, old_value: int, new_value: int)
signal ego_zero()
signal heat_changed(old_value: int, new_value: int)
signal heat_overheat()

# === Dialogue signals ===
signal dialogue_started(dialogue_id: String)
signal dialogue_ended(dialogue_id: String)
signal choice_made(choice_id: String, choice_data: Dictionary)
signal flag_set(flag_name: String, value: bool)

# === Scene signals ===
signal scene_change_requested(scene_id: String)
signal scene_transition_started()
signal scene_transition_finished()

# === Phone signals ===
signal phone_message_received(message_data: Dictionary)
signal phone_opened()
signal phone_closed()

# === Combat signals ===
signal combat_started()
signal combat_round_started(round_number: int)
signal combat_round_ended(round_number: int)
signal combat_action_chosen(action: String)
signal combat_enemy_acted(enemy_id: String, action: String)
signal combat_ended(outcome: String)
signal passive_insert_triggered(line: String)

# === Hub signals ===
signal hub_segment_consumed()
signal hub_timer_expired()

# === NPC signals ===
signal npc_interaction_started(npc_id: String)
signal npc_interaction_ended(npc_id: String)
