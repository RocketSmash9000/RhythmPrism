extends AudioStreamPlayer

var meta
var sound_player
var local_loop

# This dictionary right here contains a list of every single audio file used for polos.
# If (for example) polo 3 had only one loop instead of 2, make the two preload functions
# at "3: [...]" load the exact same file.
# If the mod had more loops, add more preload functions to the array.
var sounds_dict: Dictionary[int, Array] = {
	# Godot it'd be nice if I could make the values Array[Resource] :)
	1: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	2: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	3: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	4: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	5: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	6: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	7: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	8: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	9: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	10: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	11: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	12: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	13: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	14: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	15: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	16: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	17: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	18: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	19: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")],
	20: [preload("res://Sound/V5 FitnessGram 1.mp3"), preload("res://Sound/V5 FitnessGram 2.mp3")]
}

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
	
	if (meta != 0):
		# This single line right here is what makes the sound play.
		# Since v0.3.1 the sound loading has been overhauled to
		# a less monolithic, hardcoded mess. One line is a lot prettier,
		# don't you think?
		set_stream(sounds_dict[meta][GlobalVars.current_loop-1])
	else:
		# Required for godot to not make polos play sounds
		# when they're supposed to not play any sound.
		return
	
	if !$"../../..".first_polo and !already_playing and !GlobalVars.picked_polos.is_empty():
		await $"../../../Loop".timeout
		play()
		already_playing = true
	else:
		play()
		already_playing = true
