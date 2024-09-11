extends RigidBody3D


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		linear_velocity.y = 5.0
		linear_velocity.z = 1.0
