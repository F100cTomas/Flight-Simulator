extends Node3D

const DEFAULT_ZOOM: float = 10
const SENSITIVITY: float = 1.0 / 360
const DEFAULT_ROTATION: Vector3 = Vector3(0.0, deg_to_rad(-90.0), 0.0)

var is_panning: bool = false
var is_locked: bool = false
var pan_coords: Vector2
var og_rotation: Vector3
var og_cam_rotation: Vector3

func _ready() -> void:
	$Camera3D.position = Vector3(0.0, 0.0, DEFAULT_ZOOM)
	global_rotation = DEFAULT_ROTATION

func _input(event: InputEvent) -> void:
	$Camera3D.position.z += Input.get_axis("Zoom In", "Zoom Out") * 2.0
	if Input.is_action_just_pressed("Pan Around"):
		is_panning = true
		pan_coords = get_viewport().get_mouse_position()
		og_rotation = global_rotation
		og_cam_rotation = $Camera3D.rotation
	elif Input.is_action_just_released("Pan Around"):
		is_panning = false
	if Input.is_action_pressed("Reset Camera"):
		$Camera3D.position = Vector3(0.0, 0.0, DEFAULT_ZOOM)
		$Camera3D.rotation = Vector3(0.0, 0.0, 0.0)
		global_rotation = DEFAULT_ROTATION

func _process(delta: float) -> void:
	global_position = get_parent().global_position
	if is_panning:
		var pan_difference: Vector2 = pan_coords - get_viewport().get_mouse_position()
		if Input.is_action_pressed("Change View Direction"):
			$Camera3D.rotation = og_cam_rotation + Vector3(pan_difference.y * SENSITIVITY, pan_difference.x * SENSITIVITY, 0.0)
		else:
			global_rotation = og_rotation + Vector3(pan_difference.y * SENSITIVITY, pan_difference.x * SENSITIVITY, 0.0)
