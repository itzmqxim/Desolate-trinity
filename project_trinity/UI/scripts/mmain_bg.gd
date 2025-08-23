extends ColorRect

@export var audio_player: AudioStreamPlayer2D
@export var base_color := Color("#0a0a1a")
@export var pulse_color := Color("#3a2c84")
@export var bass_range := Vector2(60, 120)
@export var sub_bass_range := Vector2(30, 60) 
@export var punch_threshold := 0.15
@export var fade_speed := 8.0

var spectrum: AudioEffectSpectrumAnalyzerInstance
var current_brightness := 0.0

func _ready():
	var bus_idx = AudioServer.get_bus_index("Music")
	spectrum = AudioServer.get_bus_effect_instance(bus_idx, 0)
	mouse_filter = MOUSE_FILTER_IGNORE

func _process(delta):
	if !audio_player or !audio_player.playing or !spectrum:
		color = base_color
		return
	
	var kick_energy = spectrum.get_magnitude_for_frequency_range(
		bass_range.x, bass_range.y
	).length()
	
	var sub_energy = spectrum.get_magnitude_for_frequency_range(
		sub_bass_range.x, sub_bass_range.y
	).length()
	
	var bass_impact = (kick_energy * 1.5 + sub_energy * 0.5) / 2.0
	
	# Brightness control
	if bass_impact > punch_threshold:
		current_brightness = 1.0
	else:
		current_brightness = move_toward(current_brightness, 0.0, delta * fade_speed)
	
	var curved_brightness = ease(current_brightness, 3.0)
	color = base_color.lerp(pulse_color, curved_brightness)
