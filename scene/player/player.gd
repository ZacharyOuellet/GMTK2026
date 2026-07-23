extends CharacterBody3D

@export var player_id : int = 1
@export var speed : int = 10

var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	if player_id == 1:
		var material = StandardMaterial3D.new()
		$MeshInstance3D.material_override = material
		material.albedo_color = Color(1.0, 0.847, 0.004, 1.0)
	
	if player_id == 2:
		var material = StandardMaterial3D.new()
		$MeshInstance3D.material_override = material
		material.albedo_color = Color(0.302, 0.0, 0.976, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if player_id == 1:
		direction = Input.get_vector("left_1", "right_1", "up_1", "down_1")
	if player_id == 2:
		direction = Input.get_vector("left_2", "right_2", "up_2", "down_2")
	
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed
	move_and_slide()
