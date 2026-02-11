extends AudioStreamPlayer

var meta
var sound_player

# This dictionary right here contains a list of every single audio file used for polos.
# If (for example) polo 3 had only one loop instead of 2, make the two preload functions
# at "3: [...]" load the exact same file.
# If the mod had more loops, add more preload functions to the array.
const SOUNDS_DICT: Dictionary[int, Array] = {
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

# For information on how to use this constant, please read 'EffectParser.md'.
# Leave empty for no effects.
# Only one effect is allowed per bus.
const ASSOCIATED_EFFECTS: Dictionary[int, Array] = {
	1: [], # You can replace the brackets with '["Reverb", 0.8, 0.5, 1, 0, 1, 0.5]' to add the reverb effect
	2: [],
	3: [],
	4: [],
	5: [],
	6: [],
	7: [],
	8: [],
	9: [],
	10: [],
	11: [],
	12: [],
	13: [],
	14: [],
	15: [],
	16: [],
	17: [],
	18: [],
	19: [],
	20: []
}

var already_playing = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sound_player = LogStream.new("Polo/SoundPlayer" + str(get_meta("AudioID")))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# When the signal is received, it will play the corresponding sound, only if the timer has reached
# zero (aka when the first polo is placed) or if the timer has just been reset.
func _when_parent_node_new_loop(loop: int) -> void:
	# The script has a 75 millisecond tolerance for lag spikes
	# Tolerance is expressed in that -0.075. In most cases it should be a big enough tolerance.
	# If the mod is resource intensive, you should consider increasing the tolerance to -0.1.
	if !$"../../../Loop".time_left <= (GlobalVars.loop_seconds-0.075) or $"../../../Loop".time_left == 0:
		sound_play(loop)

func sound_play(loop: int) -> void:
	meta = get_parent().type # Save the ID of the sound to play stored in the polo
	sound_player.debug("Meta = " + str(meta))
	
	if GlobalVars.picked_polos.find(meta) == -1:
		sound_player.debug("Sound corresponding to polo " + str(meta) + " not found in picked polos list! Stopping sound playback...")
		stop()
		return
	
	if (meta != 0):
		# This single line right here is what makes the sound play.
		# Since v0.3.1 the sound loading has been overhauled to
		# a less monolithic, hardcoded mess. One line is a lot prettier,
		# don't you think?
		set_stream(SOUNDS_DICT[meta][loop-1])
		
		# This other line is what parses the effects and adds them to their respective buses.
		parseEffect(ASSOCIATED_EFFECTS[meta], get_parent().name.to_int())
	else:
		# Required for godot to not make polos play sounds
		# when they're supposed to not play any sound.
		return
	
	play()
	already_playing = true

# Gets passed an array of effects and the meta of a polo.
# Will attach the effects of a polo to the appropriate bus.
# It's quite the cool function, isn't it?
func parseEffect(effect: Array, busID: int):
	if effect.is_empty() or typeof(effect[0]) != TYPE_STRING:
		sound_player.debug("Invalid data type of effect. No effect will apply.")
		return
	var effect_name: String = effect[0]
	match effect_name.to_lower():
		"reverb":
			var reverb: AudioEffect = AudioEffectReverb.new()
			if effect.size() == 7:
				reverb.room_size = effect[1]
				reverb.damping = effect[2]
				reverb.spread = effect[3]
				reverb.hipass = effect[4]
				reverb.dry = effect[5]
				reverb.wet = effect[6]
			if AudioServer.get_bus_effect_count(busID) != 1:
					AudioServer.add_bus_effect(busID, reverb)
					sound_player.info("Applied reverb effect to polo number " + str(busID))
		"compress":
			var compression: AudioEffect = AudioEffectCompressor.new()
			if effect.size() == 7:
				compression.threshold = effect[1]
				compression.ratio = effect[2]
				compression.gain = effect[3]
				compression.attack_us = effect[4]
				compression.release_ms = effect[5]
				compression.mix = effect[6]
			if AudioServer.get_bus_effect_count(busID) != 1:
				AudioServer.add_bus_effect(busID, compression)
				sound_player.info("Applied compression effect to polo number " + str(busID))
		"chorus":
			var chorus: AudioEffect = AudioEffectChorus.new()
			if effect.size() == 4:
				chorus.voice_count = effect[1]
				chorus.dry = effect[2]
				chorus.wet = effect[3]
			if AudioServer.get_bus_effect_count(busID) != 1:
				AudioServer.add_bus_effect(busID, chorus)
				sound_player.info("Applied chorus effect to polo number " + str(busID))
		"distort":
			var distortion: AudioEffect = AudioEffectDistortion.new()
			if effect.size() == 6:
				var distortion_name: String = effect[1]
				match distortion_name.to_lower():
					"clip":
						distortion.mode = AudioEffectDistortion.MODE_CLIP
					"atan":
						distortion.mode = AudioEffectDistortion.MODE_ATAN
					"tan":
						distortion.mode = AudioEffectDistortion.MODE_ATAN
					"lofi":
						distortion.mode = AudioEffectDistortion.MODE_LOFI
					"lo-fi":
						distortion.mode = AudioEffectDistortion.MODE_LOFI
					"overdrive:":
						distortion.mode = AudioEffectDistortion.MODE_OVERDRIVE
					"wave":
						distortion.mode = AudioEffectDistortion.MODE_WAVESHAPE
					_:
						sound_player.debug("No valid distortion mode found. No effect will apply.")
						return
				distortion.pre_gain = effect[2]
				distortion.keep_hf_hz = effect[3]
				if distortion_name.to_lower() != "overdrive":
					distortion.drive = effect[4]
				distortion.post_gain = effect[5]
			if AudioServer.get_bus_effect_count(busID) != 1:
				AudioServer.add_bus_effect(busID, distortion)
				sound_player.info("Applied distortion effect to polo number " + str(busID))
		_:
			sound_player.debug("Effect does not match any from the supported list. No effect will aply.")
			return

# Removes the effect associated with a polo when it's banished to the shadow realm
func removeEffect(busID: int):
	AudioServer.remove_bus_effect(busID, 0)
	sound_player.debug("Removed effect from polo number " + str(busID))
