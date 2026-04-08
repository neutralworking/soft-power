extends Node2D

const HUDScene := preload("res://ui/hud/hud.tscn")
const DialogueBoxScene := preload("res://ui/dialogue_box/dialogue_box.tscn")
const PhoneUIScene := preload("res://ui/phone_ui/phone_ui.tscn")
const TransitionScene := preload("res://ui/transition/transition.tscn")

var scene_container: Node2D
var ui_layer: CanvasLayer
var transition_layer: CanvasLayer
var transition_rect: ColorRect


func _ready() -> void:
	# Scene container for location scenes
	scene_container = Node2D.new()
	scene_container.name = "SceneContainer"
	add_child(scene_container)

	# UI Layer (layer 10) for HUD and dialogue
	ui_layer = CanvasLayer.new()
	ui_layer.name = "UILayer"
	ui_layer.layer = 10
	add_child(ui_layer)

	var hud := HUDScene.instantiate()
	hud.name = "HUD"
	ui_layer.add_child(hud)

	var dialogue_box := DialogueBoxScene.instantiate()
	dialogue_box.name = "DialogueBox"
	ui_layer.add_child(dialogue_box)

	var phone_ui := PhoneUIScene.instantiate()
	phone_ui.name = "PhoneUI"
	ui_layer.add_child(phone_ui)

	# Transition Layer (layer 20) for fade overlay
	transition_layer = CanvasLayer.new()
	transition_layer.name = "TransitionLayer"
	transition_layer.layer = 20
	add_child(transition_layer)

	transition_rect = TransitionScene.instantiate()
	transition_rect.name = "Transition"
	transition_layer.add_child(transition_rect)

	# Wire up SceneManager
	SceneManager.scene_container = scene_container
	SceneManager.transition_overlay = transition_rect

	# Start the game
	SceneManager.change_scene("camden_approach")
