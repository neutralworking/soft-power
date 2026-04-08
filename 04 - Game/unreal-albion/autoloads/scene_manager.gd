extends Node

const SCENE_PATHS: Dictionary = {
	"camden_approach": "res://scenes/locations/camden_approach/camden_approach.tscn",
	"door_negotiation": "res://scenes/locations/door_negotiation/door_negotiation.tscn",
	"albion_main_room": "res://scenes/locations/albion_main_room/albion_main_room.tscn",
	"back_room": "res://scenes/locations/back_room/back_room.tscn",
	"stage_confrontation": "res://scenes/locations/stage_confrontation/stage_confrontation.tscn",
	"ending_breakthrough": "res://scenes/locations/endings/ending_breakthrough.tscn",
	"ending_compromise": "res://scenes/locations/endings/ending_compromise.tscn",
	"ending_fold": "res://scenes/locations/endings/ending_fold.tscn",
}

const FADE_DURATION: float = 0.5

var current_scene_id: String = ""
var scene_container: Node = null
var transition_overlay: ColorRect = null
var _transitioning: bool = false

signal scene_loaded(scene_id: String)


func _ready() -> void:
	EventBus.scene_change_requested.connect(change_scene)


func change_scene(scene_id: String) -> void:
	if _transitioning:
		return
	if not SCENE_PATHS.has(scene_id):
		push_error("SceneManager: Unknown scene '%s'" % scene_id)
		return

	_transitioning = true
	EventBus.scene_transition_started.emit()

	# Fade out
	if transition_overlay:
		var tween := create_tween()
		tween.tween_property(transition_overlay, "color:a", 1.0, FADE_DURATION)
		await tween.finished

	# Remove current scene
	if scene_container:
		for child in scene_container.get_children():
			child.queue_free()

	# Load new scene
	var scene_resource := load(SCENE_PATHS[scene_id])
	if not scene_resource:
		push_error("SceneManager: Could not load scene '%s'" % scene_id)
		_transitioning = false
		return

	var instance := scene_resource.instantiate()
	if scene_container:
		scene_container.add_child(instance)

	current_scene_id = scene_id

	# Fade in
	if transition_overlay:
		var tween := create_tween()
		tween.tween_property(transition_overlay, "color:a", 0.0, FADE_DURATION)
		await tween.finished

	_transitioning = false
	scene_loaded.emit(scene_id)
	EventBus.scene_transition_finished.emit()


func go_to_ending() -> void:
	var ending_id := GameState.get_ending()
	change_scene(ending_id)
