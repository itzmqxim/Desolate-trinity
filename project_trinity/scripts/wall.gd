@tool  # Allows editor preview
extends Node2D

@export var grid_size := Vector2(32, 32)  # Match your game's grid

func _ready():
	position = position.snapped(grid_size)

func _process(delta):
	if Engine.is_editor_hint:  # Snap in editor too
		position = position.snapped(grid_size)
