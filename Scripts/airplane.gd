extends CharacterBody3D

const EXPLOSION = preload("res://Assets/Sounds/vine-boom.mp3")

const SPEED = 20.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	$DuchKieva1/AnimationPlayer.play("Krychle_001Action")

func get_particles() -> GPUParticles3D:
	var particles: GPUParticles3D = GPUParticles3D.new()
	particles.amount = 10
	particles.lifetime = 0.3
	particles.draw_pass_1 = SphereMesh.new()
	var material: ParticleProcessMaterial = ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	material.emission_sphere_radius = 1.0
	material.gravity = Vector3(0, -10.0, 0)
	material.initial_velocity = Vector2(0.0, 30.0)
	material.direction = Vector3(0.0, 1.0, 0.0)
	material.spread = 360.0
	var gradient: Gradient = Gradient.new()
	gradient.add_point(0.0, Color(0.5, 0.5, 0.5, 1.0))
	gradient.add_point(1.0, Color(1.0, 0.5, 0.5, 0.0))
	var gradient_texture: GradientTexture2D = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	material.color_ramp = gradient_texture
	material.color = Color(0.5, 0.5, 0.5)
	material.scale = Vector2(0.5, 0.5)
	particles.process_material = material
	particles.emitting = true
	return particles

func rot(delta: float) -> void:
	rotate(global_basis.x, Input.get_axis("Pitch Down", "Pitch Up") * delta)
	rotate(global_basis.y, Input.get_axis("Yaw Right", "Yaw Left") * delta)
	rotate(global_basis.z, Input.get_axis("Roll Clockwise", "Roll Counter-Clockwise") * delta)

func destroy(object) -> void:
	if object is RigidBody3D:
		for b in object.get_colliding_bodies():
			b.wake_up()
	var particles : GPUParticles3D = get_particles()
	particles.position = object.position
	object.add_sibling(particles)
	object.queue_free()
	var timer: Timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	var timeout = func() -> void:
		particles.queue_free()
	timer.connect("timeout", timeout)
	particles.add_child(timer)
	var audio_player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	audio_player.stream = EXPLOSION
	particles.add_child(audio_player)
	timer.start()
	audio_player.play()

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
	if move_and_slide():
		for i in get_slide_collision_count():
			var body = get_slide_collision(i).get_collider()
			if body is RigidBody3D:
				destroy(body)
				var cam: Camera3D = $Camera3D
				remove_child(cam)
				$"..".add_child(cam)
				destroy(self)
