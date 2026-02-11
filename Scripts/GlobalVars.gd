extends Node
# This script contains needed variables. Expect errors if you delete any
# Define variables here if you need to access them from multiple scripts
# Define variables under this comment and above func _ready()

var mouse_up: bool = false # Controls when the mouse has been unclicked
var icon_meta: int = 0 # Metadata of the carried icon, aka its identifier
var carrying_icon: bool = false # Self-explanatory

var mouse_in_top_part: bool = false
var mouse_in_bottom_part: bool = false

var picked_polos = [] # Used to keep track of the polos that have been picked

var reset: bool = false # Self-explanatory

var target_polo: int = 0 # This stores the target polo of the Control Menu

# Use these to set the time in seconds it takes to complete.
# And the amount of loops it takes to return to the first loop.
# The loop indicator does not support more than 2 loops.
# So you may want to add code to implement it.
# Since v1.0 there should be no delay when sounds play,
var loop_seconds = 6 # Amount of seconds a loop takes to complete
var loop_amount: int = 2 # Amount of loops to play before going back to the first loop

var current_loop: int = 1 # Don't change this variable. It'll mess with the code

# This doesn't mean no volume. It means that the volume is the same as the volume
# of the audio files that play. A negative number will decrease volume and vice versa.
var master_volume: float = 0.0

func _ready() -> void:
	pass


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

func set_polo_animation(meta):
	return load("res://Assets/Polos/" + str(meta) + "/" + str(meta) + ".tres")
