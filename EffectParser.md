# Effect parser
The effect parser is a feature added in RhythmPrism v0.4. It grabs the effects listed in an array of effects and applies them to the audio bus of the corresponding polo. To correctly apply the effects, you will need to specify the effects in the `associated_effects` constant following the examples:
`5: ["Reverb", 0.8, 0.5, 1, 0, 1, 0.5],`
`5: ["Reverb"],`

## Breakdown
- The first number (5 in the example) represents the polo number 1-20 (by default) to which the effect is associated.
- "Reverb" is the name of the effect to apply. For a list of all the available effects, see `Possible effects`.
- The following numbers are the options with which the effect initialises. If they're not found, default settinfs will apply.

## Possible effects
Here are the names of the possible appliable effects. They will only apply if the name is written exactly as it's listed. Writing in lowercase or uppercase doesn't make a difference. The settings appear in the same order as they should be used.
- `Reverb`: Applies reverb.
	`["Reverb", 0.8, 0.5, 1, 0, 1, 0.5]`
	- Room Size: Defaults to 0.8. Max of 1. Bigger means more echo.
	- Damping: Defaults to 0.5. Max of 1. Defines how much sound the imaginary walls reflect.
	- Spread: Defaults to 1. Max of 1.
	- High-pass: Defaults to 0. Max of 1. For values higher than 0, will cut lower frequencies.
	- Dry: Defaults to 1. Max of 1. Defines how much of the original sound is used.
	- Wet: Defaults to 0.5. Max of 1. Defines how much of the modified sound is used.
- `Compress`: Applies a sound compressor.
	`["Compress", 0, 4, 0, 20, 250, 1]`
	- Threshold: Default of 0. Ranges from -60 to 0. Level (in dB) above which compression is applied.
	- Ratio: Default of 4. Ranges from 1 to 48. Is the level of compression. Higher means more compression.
	- Gain: Default of 0. Ranges from -20 to 20. Adds/subtracts volume.
	- Attack: Default of 20. Ranges from 20 to 2000. Reaction time of the compressor (expressed in microseconds). Higher means it'll take more time to apply the compression once the threshold is surpassed.
	- Release: Default of 250. Ranges from 20 to 2000. The time it takes (in milliseconds) for the compressor to stop compressing once the volume goes down.
	- Mix: Default of 1. From 0 to 1. Balance between original and modified audio. 0 means unmodified only and 1 means modified only.
- `Chorus`: Applies a chorus effect to voices.
	`["Chorus", 2, 1, 0.5]`
	- Voice count: Defaults to 2. Minimum of 1. Adds said amount of voices.
	- Dry: Defaults to 1. Ranges from 0 to 1. Amount of unmodified audio to output.
	- Wet: Defaults to 0.5. Ranges from 0 to 1. Amount of modified audio to output.
	Each voice has its own settings. Due to complexity, these settings will be kept as default.
- `Distort`: Will distort the original waveform, often creating a "crunchy" feel.
	`["Reverb", "clip", 0, 16000, 0, 0]`
	- Mode: Defaults to "clip". The possible modes are:
		- "clip": Cuts the top and bottom of the waveform.
		- "atan" or "tan": No description provided in official documentation.
		- "lofi" or "lo-fi": Similar to bit crunching, reduces the resolution of a waveform.
		- "overdrive": Emulates the distortion of an amplifier in solid-state music (like guitars). Drive option takes no effect in this mode.
		- "wave": Used by electronic music, is used to achieve an extra abrasive sound.
	- Pre gain: Defaults to 0. Ranges from -60 to 60. Increases/decreases volume before applying the effect.
	- Keep high frequency: Defaults to 16000. Ranges from 1 to 20000. Frequencies higher than this value will not be affected by the filter.
	- Drive: Defaults to 0. Max of 1. Distortion power of effect.
	- Post gain: Same as pre gain but applies after the effect is applied.
