extends Node2D

var button_type = null

func _ready():
	$ColorRect.show()
	$fade_dark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$fade_dark.show()
	$fade_dark/Fadetimer.start()
	$fade_dark/AnimationPlayer.play("Fade_out")
func _process(delta):
	pass

func _on_start_pressed():
	button_type = "start"
	$fade_dark.show()
	$fade_dark/Fadetimer.start()
	$fade_dark/AnimationPlayer.play("Fade_in")

func _on_settings_pressed():
	button_type = "settings"
	$fade_dark.show()
	$fade_dark/Fadetimer.start()
	$fade_dark/AnimationPlayer.play("Fade_in")

func _on_quit_pressed():
	get_tree().quit()


func _on_fade_timer_timeout():
	if button_type == "start":
		if randf() < 0.5:  # 50% chance
			get_tree().change_scene_to_file("res://Reusables/dev/map_office.tscn")
		else:
			get_tree().change_scene_to_file("res://Reusables/dev/map_abstract.tscn")  # Your other scene
	elif button_type == "settings":
		get_tree().change_scene_to_file("res://Reusables/UserInterface/settings.tscn")
