extends Node
# This script contains needed variables. Expect errors if you delete any
# Define variables here if you need to access them from multiple scripts
# Define variables under this comment and above func _ready()

var mouse_up: bool = false # Controls when the mouse has been unclicked
var icon_meta: int = 0 # Metadata of the carried icon, aka its identifier
var carrying_icon: bool = false # Self-explanatory

var mouse_in_top_part: bool = false
var mouse_in_bottom_part: bool = false

## Used to keep track of the polos that have been picked
var picked_polos = []

## Self-explanatory
var reset: bool = false

## This stores the target polo of the Control Menu
var target_polo: int = 0

# Use these to set the time in seconds it takes to complete.
# And the amount of loops it takes to return to the first loop.
# The loop indicator does not support more than 2 loops.
# So you may want to add code to implement it.
# Since v1.0 there should be no delay when sounds play.
## Amount of seconds a loop takes to complete
var loop_seconds = 6
## Amount of loops to play before going back to the first loop
var loop_amount: int = 2

var current_loop: int = 1 # Don't change this variable. It'll mess with the code

## This doesn't mean no volume. It means that the volume is the same as the volume
## of the audio files that play. A negative number will decrease volume and vice versa.
var master_volume: float = 0.0

## Toggles what mode of the lorebook to use: [br] [br]
## [code]0[/code] - Lorebook disabled, button will be hidden. [br]
## [code]1[/code] - Lore per polo. Has as many pages as polos. [br]
## [code]2[/code] - Lorebook mode. The pages contain lore of the mod's universe. Unlimited pages.
var lorebook_mode: int = 1

## RP v1.x supports two versions of buses: Legacy and V2.
## Legacy version uses the dictionary in AudioPlayer.gd to parse the effects and 7 buses (plus Master).
## V2 uses 20 (plus Master) buses. Each bus corresponds to one polo and is independent. [br]
## Legacy will eventually be unsupported in future versions. It's recommended to use V2.
## If you want to use Legacy, change the number to 1. [br]
## To give a polo a certain effect open the Audio menu in the bottom bar and edit its
## corresponding bus effect.
const bus_layout = 2

func _ready() -> void:
	# Switches bus layout to Legacy if project isn't set to use V2.
	if bus_layout != 2:
		AudioServer.set_bus_layout(preload("res://default_bus_layout.tres"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_viewport().get_mouse_position().y <= 728: # If this triggers, the mouse is in the top part
		mouse_in_top_part = true
		mouse_in_bottom_part = false
	
	if get_viewport().get_mouse_position().y > 728: # If this triggers, the mouse is in the bottom part
		mouse_in_bottom_part = true
		mouse_in_top_part = false
	
	# Sets the current loop to 1 if there are no picked polos
	if picked_polos.is_empty():
		current_loop = 1
	
	# When U button is pressed, increases master volume.
	if Input.is_action_just_pressed("volume_up"):
		if AudioServer.is_bus_mute(0): # Unmutes if muted
			AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0)+0.5)
		master_volume = AudioServer.get_bus_volume_db(0)
	
	# When I button is pressed, decreases master volume.
	if Input.is_action_just_pressed("volume_down"):
		if AudioServer.is_bus_mute(0): # Unmutes if muted
			AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0)-0.5)
		master_volume = AudioServer.get_bus_volume_db(0)
	
	# If O button is pressed, mute the whole thing.
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))

## Returns the asset that corresponds to a specific polo. [br]
## [code]meta[/code] = Number of the polo (1-7 by default)
func set_polo_animation(meta) -> Resource:
	return load("res://Assets/Polos/" + str(meta) + "/" + str(meta) + ".tres")

## Loads a JSON file located at [code]path[/code] as a dictionary
func load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("File not found: " + path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var result = json.parse(text)

	if result != OK:
		push_error("JSON Parse Error: " + json.get_error_message())
		return {}

	return json.get_data()
