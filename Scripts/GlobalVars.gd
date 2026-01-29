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

func set_polo_animation(meta):
	match meta:
		1:
			return load("res://Assets/Polos/1/1.tres")
		2:
			return load("res://Assets/Polos/2/2.tres")
		3:
			return load("res://Assets/Polos/3/3.tres")
		4:
			return load("res://Assets/Polos/4/4.tres")
		5:
			return load("res://Assets/Polos/5/5.tres")
		6:
			return load("res://Assets/Polos/6/6.tres")
		7:
			return load("res://Assets/Polos/7/7.tres")
		8:
			return load("res://Assets/Polos/8/8.tres")
		9:
			return load("res://Assets/Polos/9/9.tres")
		10:
			return load("res://Assets/Polos/10/10.tres")
		11:
			return load("res://Assets/Polos/11/11.tres")
		12:
			return load("res://Assets/Polos/12/12.tres")
		13:
			return load("res://Assets/Polos/13/13.tres")
		14:
			return load("res://Assets/Polos/14/14.tres")
		15:
			return load("res://Assets/Polos/15/15.tres")
		16:
			return load("res://Assets/Polos/16/16.tres")
		17:
			return load("res://Assets/Polos/17/17.tres")
		18:
			return load("res://Assets/Polos/18/18.tres")
		19:
			return load("res://Assets/Polos/19/19.tres")
		20:
			return load("res://Assets/Polos/20/20.tres")
