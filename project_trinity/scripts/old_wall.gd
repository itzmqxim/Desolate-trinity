extends StaticBody2D

func _ready():
	# Wait for the sprite to be ready
	await get_tree().process_frame
	
	if $Sprite2D.texture:  # Check if sprite has texture
		create_occluder_from_collision()

func create_occluder_from_collision():
	var occluder = LightOccluder2D.new()
	var polygon = OccluderPolygon2D.new()
	
	if $CollisionShape2D.shape is RectangleShape2D:
		var extents = $CollisionShape2D.shape.size / 2
		polygon.polygon = PackedVector2Array([
			Vector2(-extents.x, -extents.y),
			Vector2(extents.x, -extents.y),
			Vector2(extents.x, extents.y),
			Vector2(-extents.x, extents.y)
		])
	elif $CollisionShape2D.shape is ConvexPolygonShape2D:
		polygon.polygon = $CollisionShape2D.shape.points
	
	occluder.occluder = polygon
	add_child(occluder)
