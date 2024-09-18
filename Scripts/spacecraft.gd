extends Node3D

var rigidbody: RigidBody3D

func get_rigidbody() -> RigidBody3D:
	for child in get_children():
		if child is RigidBody3D:
			return child
	push_error("Rigidbody3D not found")
	return null

func _ready() -> void:
	rigidbody = get_rigidbody()

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Speed Up"):
		rigidbody.apply_force(Vector3(0.0, 30.0, 0.0))

func _process(delta: float) -> void:
	global_position = rigidbody.global_position
