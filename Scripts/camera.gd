extends Node3D

const DEFAULT_ZOOM: float = 10
const SENSITIVITY: float = 1.0 / 360

var is_panning: bool = false
var is_locked: bool = false
var pan_coords: Vector2
var og_rotation: Vector3
var og_cam_rotation: Vector3
var og_parent_rotation: Vector3
var relative_rotation: Vector3 = Vector3(0.0, 0.0, 0.0)
var lock_rotation: Vector3 = Vector3(0.0, 0.0, 0.0)

func _ready() -> void:
	$Camera3D.position = Vector3(0.0, 0.0, DEFAULT_ZOOM)

func _input(event: InputEvent) -> void:
	$Camera3D.position.z += Input.get_axis("Zoom In", "Zoom Out") * 2.0
	if Input.is_action_just_pressed("Pan Around"):
		is_panning = true
		pan_coords = get_viewport().get_mouse_position()
		og_rotation = relative_rotation
		og_cam_rotation = $Camera3D.rotation
	elif Input.is_action_just_released("Pan Around"):
		is_panning = false
	if Input.is_action_just_pressed("lock rotation"):
		is_locked = not is_locked
		if is_locked:
			og_parent_rotation = get_parent().global_rotation
	if Input.is_action_pressed("Reset Camera"):
		$Camera3D.position = Vector3(0.0, 0.0, DEFAULT_ZOOM)
		$Camera3D.rotation = Vector3(0.0, 0.0, 0.0)
		global_rotation = Vector3(0.0, 0.0, 0.0)

func _process(delta: float) -> void:
	global_position = get_parent().global_position
	var relative_lock_rotation: Vector3 = Vector3(0.0, 0.0, 0.0)
	if is_locked:
		relative_lock_rotation = get_parent().global_rotation - og_parent_rotation
	if is_panning:
		var pan_difference: Vector2 = pan_coords - get_viewport().get_mouse_position()
		if Input.is_action_pressed("Change View Direction"):
			$Camera3D.rotation = og_cam_rotation + Vector3(pan_difference.y * SENSITIVITY, pan_difference.x * SENSITIVITY, 0.0)
		else:
			relative_rotation = og_rotation + Vector3(pan_difference.y * SENSITIVITY, pan_difference.x * SENSITIVITY, 0.0)
	global_rotation = relative_lock_rotation + relative_rotation
