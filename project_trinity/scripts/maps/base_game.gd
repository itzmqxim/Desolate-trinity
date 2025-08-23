extends Node2D

# Define your spawn points as an array of Vector2 positions
@onready var spawn_points = get_tree().get_nodes_in_group("spawn_points")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Example: Spawn player at random point
	var player = load("res://reusables/player.tscn").instantiate()
	player.position = spawn_points.pick_random().position
	add_child(player)

	$fade_dark.show()
	$fade_dark/Fadetimer.start()
	$fade_dark/AnimationPlayer.play("Fade_out")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
