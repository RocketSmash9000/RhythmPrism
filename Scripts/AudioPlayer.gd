extends AudioStreamPlayer

var meta
var sound_player
var local_loop

var already_playing = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	local_loop = GlobalVars.current_loop
	sound_player = LogStream.new("Polo/SoundPlayer" + str(get_meta("AudioID")))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if local_loop != GlobalVars.current_loop:
		if $"../../..".first_polo:
			sound_play()
			$"../../..".first_polo = false
			already_playing = true
		elif already_playing:
			sound_play()
		local_loop = GlobalVars.current_loop

func sound_play() -> void:
	meta = get_parent().type # Save the ID of the sound to play stored in the polo
	sound_player.info("Meta = " + str(meta))
	
	#if GlobalVars.picked_polos.find(meta) == -1:
		#sound_player.info("Sound corresponding to polo " + str(meta) + " not found in picked polos list! Stopping sound playback...")
		#stop()
		#return
	
	# In case your mod has more than 2 loops, replace the 'else' with 'elif GlobalVars.current_loop == 2'
	# and add more elif's as needed, adding 1 to the contition. You will also need
	# to change the set_stream() methods so that they play the correspond to the correct sound.
	# For more info consult the wiki, or create an issue in the Amazing Engine repository.
	match meta:
		1:
			# For each individual sound you will have to substitute every '"res://Sound/V5 FitnessGram 1.mp3"' with
			# the path to your desired sound, since the previous method didn't work for exported mods.
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 2.mp3"))
		2:
			# If this polo had only one loop, you could do 'set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))'
			# directly without any if else conditionals.
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 2.mp3"))
		3:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		4:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		5:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		6:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		7:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		8:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		9:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		10:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		11:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		12:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		13:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		14:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		15:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		16:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		17:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		18:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		19:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		20:
			if GlobalVars.current_loop == 1:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
			else:
				set_stream(load("res://Sound/V5 FitnessGram 1.mp3"))
		# Paste more blocks below here if needed
		
		# Paste more blocks above here if needed
		_: # If something goes wrong...
			sound_player.info("Cannot play any sound!")
	
	if !$"../../..".first_polo and !already_playing and !GlobalVars.picked_polos.is_empty():
		await $"../../../Loop".timeout
		play()
		already_playing = true
	else:
		play()
		already_playing = true
