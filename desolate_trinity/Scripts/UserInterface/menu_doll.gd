extends Sprite2D

@export var base_move_speed := 750.0
@export var corner_hit_color_change := true
@export var rainbow_duration := 20.0
@export var rainbow_speed := 10.0
@export var rainbow_speed_multiplier := 2.5  # How much faster during rainbow

var velocity := Vector2(1, 1).normalized() * base_move_speed
var screen_size := Vector2.ZERO
var sprite_size := Vector2.ZERO
var is_rainbow_active := false
var rainbow_timer := 0.0
var hue_shift := 0.0
var current_move_speed := base_move_speed

func _ready():
	# Get initial screen size
	screen_size = get_viewport_rect().size
	# Get sprite size from texture
	sprite_size = texture.get_size() * scale
	
	# Random starting angle
	var random_angle = randf_range(-PI/4, PI/4)
	velocity = velocity.rotated(random_angle)
	current_move_speed = base_move_speed

func _process(delta):
	# Update velocity magnitude while maintaining direction
	velocity = velocity.normalized() * current_move_speed
	
	# Update position
	position += velocity * delta
	
	# Handle rainbow effect
	if is_rainbow_active:
		rainbow_timer -= delta
		hue_shift += delta * rainbow_speed
		modulate = Color.from_hsv(fmod(hue_shift, 1.0), 0.9, 0.9)
		
		if rainbow_timer <= 0:
			end_rainbow()
	
	# Camera and collision detection (rest of your existing code)
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	var camera_rect := Rect2(
		camera.global_position - screen_size/(2 * camera.zoom),
		screen_size/camera.zoom
	)
	
	var sprite_rect = Rect2(position - sprite_size/2, sprite_size)
	
	# Horizontal bouncing
	if sprite_rect.position.x <= camera_rect.position.x:
		velocity.x = abs(velocity.x)
		position.x = camera_rect.position.x + sprite_size.x/2
		on_bounce(false)
	elif sprite_rect.end.x >= camera_rect.end.x:
		velocity.x = -abs(velocity.x)
		position.x = camera_rect.end.x - sprite_size.x/2
		on_bounce(false)
		
	# Vertical bouncing
	if sprite_rect.position.y <= camera_rect.position.y:
		velocity.y = abs(velocity.y)
		position.y = camera_rect.position.y + sprite_size.y/2
		on_bounce(false)
	elif sprite_rect.end.y >= camera_rect.end.y:
		velocity.y = -abs(velocity.y)
		position.y = camera_rect.end.y - sprite_size.y/2
		on_bounce(false)
	
	check_corner_hits(camera_rect)

func end_rainbow():
	is_rainbow_active = false
	current_move_speed = base_move_speed
	modulate = Color.WHITE

func check_corner_hits(camera_rect: Rect2):
	var threshold = 5.0
	var sprite_rect = Rect2(position - sprite_size/2, sprite_size)
	
	if (sprite_rect.position.x <= camera_rect.position.x + threshold and 
		sprite_rect.position.y <= camera_rect.position.y + threshold):
		activate_rainbow()
	elif (sprite_rect.end.x >= camera_rect.end.x - threshold and 
		  sprite_rect.position.y <= camera_rect.position.y + threshold):
		activate_rainbow()
	elif (sprite_rect.position.x <= camera_rect.position.x + threshold and 
		  sprite_rect.end.y >= camera_rect.end.y - threshold):
		activate_rainbow()
	elif (sprite_rect.end.x >= camera_rect.end.x - threshold and 
		  sprite_rect.end.y >= camera_rect.end.y - threshold):
		activate_rainbow()

func on_bounce(is_corner: bool):
	if is_corner and corner_hit_color_change and not is_rainbow_active:
		modulate = Color.from_hsv(randf(), 0.7, 0.9)

func activate_rainbow():
	if not is_rainbow_active:
		is_rainbow_active = true
		rainbow_timer = rainbow_duration
		hue_shift = 0.0
		current_move_speed = base_move_speed * rainbow_speed_multiplier
		# $RainbowSound.play()
