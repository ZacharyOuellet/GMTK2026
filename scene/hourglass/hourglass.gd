extends RigidBody3D

@export var impulse_magnitude : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit(normalized_vector: Vector3, torque_vector : Vector3) -> void: 
	collision_layer = 2
	collision_mask = 0
	position.y = 0.1
	freeze = false
	apply_central_impulse(normalized_vector * impulse_magnitude)
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
