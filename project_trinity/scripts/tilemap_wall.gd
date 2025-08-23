extends TileMapLayer

func _ready():
	for cell in get_used_cells():
		var pos = map_to_local(cell)
		var size = tile_set.tile_size
		
		# 1. Add collision (StaticBody2D)
		var static_body = StaticBody2D.new()
		var collision = CollisionShape2D.new()
		collision.shape = RectangleShape2D.new()
		collision.shape.size = size
		static_body.position = pos
		static_body.add_child(collision)
		add_child(static_body)
		
		# 2. Add occluder (matches collision exactly)
		var occluder = LightOccluder2D.new()
		var polygon = OccluderPolygon2D.new()
		polygon.polygon = PackedVector2Array([
			-size / 2,
			Vector2(-size.x, size.y) / 2,
			size / 2,
			Vector2(size.x, -size.y) / 2
		])
		polygon.cull_mode = OccluderPolygon2D.CULL_DISABLED  # Fixes shadow direction
		occluder.occluder = polygon
		occluder.position = pos
		add_child(occluder)
