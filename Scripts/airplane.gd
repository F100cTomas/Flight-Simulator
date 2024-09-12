extends CharacterBody3D


const SPEED = 20.0
const JUMP_VELOCITY = 4.5

func rot(delta: float) -> void:
	rotate(global_basis.x, Input.get_axis("Pitch Down", "Pitch Up") * delta)
	rotate(global_basis.y, Input.get_axis("Yaw Right", "Yaw Left") * delta)
	rotate(global_basis.z, Input.get_axis("Roll Clockwise", "Roll Counter-Clockwise") * delta)

func _physics_process(delta: float) -> void:
	rot(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity *= 0.9
	if Input.is_key_pressed(KEY_SPACE):
		var direction: Vector3 = -global_basis.z.normalized() + global_basis.y.normalized() / 2
		velocity += direction * delta * SPEED
	velocity *= 0.99
	move_and_slide()
