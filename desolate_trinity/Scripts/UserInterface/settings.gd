extends Node2D

var button_type = null

func _ready():
	$ColorRect.show()
	$fade_dark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$fade_dark.show()
	$fade_dark/Fadetimer.start()
	$fade_dark/AnimationPlayer.play("Fade_out")


func _on_return_pressed():
	button_type = "return"
	$fade_dark.show()
	$fade_dark/Fadetimer.start()
	$fade_dark/AnimationPlayer.play("Fade_in")


func _on_settings_pressed():
	get_tree().quit()


func _on_reset_pressed():
	button_type = "reset"
	$fade_dark.show()
	$fade_dark/Fadetimer.start()
	$fade_dark/AnimationPlayer.play("Fade_in")


func _on_fadetimer_timeout():
	if button_type == "return":
		get_tree().change_scene_to_file("res://Reusables/UserInterface/main_menu.tscn")
	elif button_type == "reset":
		$fade_dark.show()
		$fade_dark/Fadetimer.start()
		$fade_dark/AnimationPlayer.play("Fade_out")
