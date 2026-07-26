class_name Hourglass
extends RigidBody3D

@export var on_hit_sprite_player : AnimatedSprite3D


func _ready() -> void:
	if on_hit_sprite_player:
		on_hit_sprite_player.hide()
		on_hit_sprite_player.animation_finished.connect(_on_hit_animation_finished)


func hit(force: Vector3, torque_vector: Vector3) -> void:
	if on_hit_sprite_player:
		on_hit_sprite_player.show()
		on_hit_sprite_player.play("default")

	AudioManager.play_audio_by_type(AudioManager.AudioType.HIT)

	TimerGlobal.is_running = false;
	collision_layer = 2
	collision_mask = 0
	position.y = 0.1
	freeze = false
	apply_central_impulse(force)
	apply_torque_impulse(torque_vector)
	await get_tree().create_timer(0.1).timeout
	collision_layer = 1
	collision_mask = 1 

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Ground"):
		freeze = true
		position = $CollisionShape3D.global_position
		position.y = 0
		rotation = Vector3.ZERO
		TimerGlobal.is_running = true
		$GPUParticles3D.emitting = true

func _on_hit_animation_finished() -> void:
	print("hit animation finished")
	if on_hit_sprite_player:
		on_hit_sprite_player.hide()
