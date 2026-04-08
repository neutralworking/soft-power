extends Node

enum MusicState { SILENT, CALM, RISING, OVERHEAT }

const FADE_DURATION: float = 2.0
const AUDIO_PATHS: Dictionary = {
	MusicState.CALM: "res://assets/audio/music_calm.ogg",
	MusicState.RISING: "res://assets/audio/music_rising.ogg",
	MusicState.OVERHEAT: "res://assets/audio/music_overheat.ogg",
}

var current_state: MusicState = MusicState.SILENT
var players: Dictionary = {}


func _ready() -> void:
	# Create audio players for each state
	for state in AUDIO_PATHS:
		var player := AudioStreamPlayer.new()
		player.bus = "Master"
		player.volume_db = -80.0  # Start silent
		add_child(player)

		# Try to load the audio file
		var stream = load(AUDIO_PATHS[state])
		if stream:
			player.stream = stream
			player.play()
		players[state] = player

	EventBus.heat_changed.connect(_on_heat_changed)
	EventBus.scene_transition_started.connect(_on_transition_start)
	EventBus.scene_transition_finished.connect(_on_transition_end)


func set_state(new_state: MusicState) -> void:
	if new_state == current_state:
		return

	var old_state := current_state
	current_state = new_state

	# Fade out old
	if players.has(old_state):
		var tween_out := create_tween()
		tween_out.tween_property(players[old_state], "volume_db", -80.0, FADE_DURATION)

	# Fade in new
	if players.has(new_state):
		var tween_in := create_tween()
		tween_in.tween_property(players[new_state], "volume_db", -6.0, FADE_DURATION)


func _on_heat_changed(_old_value: int, new_value: int) -> void:
	if new_value >= 6:
		set_state(MusicState.OVERHEAT)
	elif new_value >= 3:
		set_state(MusicState.RISING)
	else:
		set_state(MusicState.CALM)


func _on_transition_start() -> void:
	set_state(MusicState.SILENT)


func _on_transition_end() -> void:
	# Reset to calm on scene load
	set_state(MusicState.CALM)
