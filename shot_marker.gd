extends Node2D

func _physics_process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	global_position = Vector2(mouse_position.x - 4, mouse_position.y - 4)
