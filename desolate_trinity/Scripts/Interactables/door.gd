extends StaticBody2D

@export var slide_distance: float = 32
@export var slide_speed: float = 100
@export var max_uses: int = 10  # Renamed from "points" for clarity
@export var slide_direction := Vector2.UP  # Configurable direction

var original_position: Vector2
var target_position: Vector2
var open := false
var remaining_uses: int

func _ready():
	original_position = position
	target_position = original_position
	remaining_uses = max_uses
	slide_direction = slide_direction.normalized()  # Ensure consistent movement speed

func _process(delta):
	if position != target_position:
		position = position.move_toward(target_position, slide_speed * delta)

func _unhandled_input(event):
	if event.is_action_pressed("e") and not is_moving():
		var player = get_tree().get_first_node_in_group("player")
		if player and position.distance_to(player.position) < 40:
			use_door()

func is_moving() -> bool:
	return position != target_position

func use_door():
	remaining_uses -= 1
	if remaining_uses <= 0:
		break_door()
	else:
		toggle_door()

func toggle_door():
	open = !open
	target_position = original_position + (slide_direction * slide_distance if open else Vector2.ZERO)

func break_door():
	# Play breaking animation/sound here if needed
	queue_free()
