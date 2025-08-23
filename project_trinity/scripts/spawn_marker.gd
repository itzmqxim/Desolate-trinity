extends Marker2D

@export var show_ing := false

func _ready():
	if not Engine.is_editor_hint() and not show_ing:
		queue_free()
