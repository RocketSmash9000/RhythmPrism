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
# There may be a delay of around 0.05 seconds or less before audio plays.
# So if your sounds are 6 seconds, try subtracting 0.01 until the desired result.
var loop_seconds = 6
var loop_amount: int = 2
var current_loop: int = 1

var master_volume: float = 1.0
var master_muted: bool = false

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
	
	if reset:
		await get_tree().create_timer(0.005).timeout # waits for 0.005 seconds
		picked_polos.clear() # Clears the list containing all currently picked polos
		current_loop = 1 # Resets the current loop to 1
		reset = false
		Log.debug("All polos reset!")
	
	# Sets the current loop to 1 if there are no picked polos
	if picked_polos.is_empty():
		current_loop = 1
	
	# When U button is pressed, increases master volume.
	if Input.is_action_just_pressed("volume_up"):
		if master_muted:
			AudioServer.set_bus_mute(0, false)
			master_muted = false
		AudioServer.set_bus_volume_linear(0, AudioServer.get_bus_volume_linear(0)+0.05)
		master_volume = AudioServer.get_bus_volume_linear(0)
	
	# When I button is pressed, decreases master volume.
	if Input.is_action_just_pressed("volume_down"):
		if master_muted:
			AudioServer.set_bus_mute(0, false)
			master_muted = false
		AudioServer.set_bus_volume_linear(0, AudioServer.get_bus_volume_linear(0)-0.05)
		master_volume = AudioServer.get_bus_volume_linear(0)
		# If the volume is zero, conversion from db to linear
		# will fail miserably and return NaN.
		# So if it happens we make the volume real close to 0.
		if is_nan(master_volume):
			AudioServer.set_bus_volume_linear(0, 0.0001)
			master_volume = 0
	
	# If O button is pressed, mute the whole thing.
	if Input.is_action_just_pressed("mute"):
		if master_muted:
			AudioServer.set_bus_mute(0, false)
			master_muted = false
		else:
			AudioServer.set_bus_mute(0, true)
			master_muted = true

func set_polo_animation(meta):
	return load("res://Assets/Polos/" + str(meta) + "/" + str(meta) + ".tres")
