extends HSlider

@export var bus_name := "Music"
var bus_index: int

func _ready():
	update_bus_index()
	
	refresh_slider_value()
	
	value_changed.connect(_on_value_changed)

func update_bus_index():
	bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("Audio bus '%s' not found! Available buses: %s" % [
			bus_name, 
			get_available_bus_names()
		])
	else:
		print("Connected to bus: ", bus_name, " (Index: ", bus_index, ")")

func refresh_slider_value():
	if bus_index != -1:
		var current_db = AudioServer.get_bus_volume_db(bus_index)
		value = db_to_linear(current_db)
		update_label()

func _on_value_changed(new_value: float):
	if bus_index == -1:
		return
		
	var new_db = linear_to_db(new_value)
	AudioServer.set_bus_volume_db(bus_index, new_db)
	update_label()
	
	print("Set bus '", bus_name, "' to: ", 
		  "%.1f dB (%.0f%%)" % [new_db, new_value * 100])

func update_label():
	if has_node("Label"):
		$Label.text = "%d%%" % round(value * 100)

func get_available_bus_names() -> String:
	var names = []
	for i in AudioServer.get_bus_count():
		names.append(AudioServer.get_bus_name(i))
	return ", ".join(names)

func bus_name_changed():
	update_bus_index()
	refresh_slider_value()
