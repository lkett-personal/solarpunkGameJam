extends Node2D

@onready var camera: Camera2D = $Camera2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			camera.position -= event.relative * camera.zoom
			camera.position.x = clamp(camera.position.x, camera.limit_left+get_viewport_rect().size.x/2, camera.limit_right-get_viewport_rect().size.x/2)
			camera.position.y = clamp(camera.position.y, camera.limit_top+get_viewport_rect().size.y/2, camera.limit_bottom-get_viewport_rect().size.y/2)
			
