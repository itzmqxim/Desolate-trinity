extends CharacterBody2D

@export var max_speed := 400.0
@export var acceleration := 1500.0
@export var deceleration := 2000.0
@export var slide_factor := 0.85
@export var dash_speed := 800.0
@export var dash_duration := 0.3
@export var dash_cooldown := 6.0
@export var speed_boost_scene := "res://Reusables/dev/map_abstract.tscn"
@export var boosted_speed := 500.0

var current_velocity := Vector2.ZERO
var is_dashing := false
var can_dash := true
var dash_direction := Vector2.ZERO
var current_max_speed := max_speed

func _ready():
	if get_tree().current_scene.scene_file_path == speed_boost_scene:
		current_max_speed = boosted_speed
		print("Speed boos scene!")
	else:
		current_max_speed = max_speed

func _physics_process(delta):
	print("Dash available: ", can_dash)
	
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	if is_dashing:
		velocity = dash_direction * dash_speed
		move_and_slide()
		return
	
	# norm
	var input_dir := Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO:
		current_velocity = current_velocity.move_toward(input_dir * current_max_speed, acceleration * delta)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration * delta)
		current_velocity *= slide_factor
	
	velocity = current_velocity
	move_and_slide()
	
	rotation = direction.angle()

func _input(event):
	if event.is_action_pressed("space") and can_dash and velocity.length() > 0:
		start_dash()

func start_dash():
	if is_dashing or not can_dash:
		return
	
	is_dashing = true
	can_dash = false
	dash_direction = velocity.normalized()
	
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true
	print("Dash cooldown finished")
