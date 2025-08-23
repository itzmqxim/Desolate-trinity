extends ColorRect

@export var min_brightness := 0.35
@export var max_brightness := 0.6
@export var cycle_speed := 2.0
@export var base_color = "#FF0000"  # Red as default color (hex format)

var time_elapsed := 0.0

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	# Validate the hex color
	if base_color.is_valid_html_color():
		base_color = Color(base_color)
	else:
		push_warning("Invalid hex color, using red as fallback")
		base_color = Color.RED

func _process(delta):
	time_elapsed += delta
	var brightness = (sin(time_elapsed * PI / cycle_speed) * 0.5 + 0.5)
	brightness = lerp(min_brightness, max_brightness, brightness)
	
	# Apply brightness to the base color
	color = Color(
		base_color.r * brightness,
		base_color.g * brightness,
		base_color.b * brightness
	)
