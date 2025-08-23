extends PointLight2D

@export var pulse_speed := 3.0
@export var pulse_variation := 0.2
@export var door_proximity_boost := 1.5  # Light intensifies near doors

func _process(delta):
	# Base pulsing
	var base_energy = 0.75 + sin(Time.get_ticks_msec() * 0.001 * pulse_speed) * pulse_variation
	
	# Detect nearby doors
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(10,0))
	var door_hit = space.intersect_ray(query)
	
	# Boost light when near doors
	if door_hit and door_hit.collider.is_in_group("doors"):
		energy = base_energy * door_proximity_boost
	else:
		energy = base_energy
