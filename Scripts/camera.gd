extends Node

func _input(event: InputEvent) -> void:
	$Camera3D.position.z += Input.get_axis("Zoom In", "Zoom Out")
	if Input.is_key_pressed(KEY_Z):
		$Camera3D.position = Vector3(0.0, 0.0, 0.0)
