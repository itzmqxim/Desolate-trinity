extends AudioStreamPlayer2D

func _ready():
	# Ensure player persists across scene changes
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Prevent audio cutting on scene changes
	bus = "Music"  # Or your preferred audio bus
