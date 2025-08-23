@tool
extends Node2D

@export var wall_scene : PackedScene
@export var grid_size := Vector2(32, 32)
@export var paint_mode := false :
	set(value):
		paint_mode = value
		notify_property_list_changed()

func _ready():
	if Engine.is_editor_hint():
		set_process_input(true)

func _input(event):
	if not Engine.is_editor_hint() or not paint_mode:
		return
	
	if event is InputEventMouseButton and event.pressed:
		var viewport := get_viewport()
		var camera := viewport.get_camera_2d()
		var mouse_pos := viewport.get_mouse_position()
		var world_pos: Vector2 = camera.project_local_ray_normal(mouse_pos).origin
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			place_wall(world_pos)
			# Workaround to maintain selection
			get_tree().create_timer(0.01).timeout.connect(
				func(): select_this_node()
			)

func place_wall(pos: Vector2):
	var snapped_pos := pos.snapped(grid_size)
	var new_wall := wall_scene.instantiate()
	new_wall.position = snapped_pos
	add_child(new_wall)
	new_wall.set_owner(get_tree().edited_scene_root)

func select_this_node():
	print("Re-selecting node")  # Debug
	var selection = EditorInterface.get_selection()
	selection.clear()
	selection.add_node(self)
