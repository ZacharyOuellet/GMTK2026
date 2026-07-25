extends CharacterBody3D

@export_group("Player")
@export var player_id : int = 1
@export var speed : int = 10
@export var speed_ratio_z_axis : int = 2.5
@export var player1_color : Color =  Color(1.0, 0.847, 0.004, 1.0)
@export var player2_color : Color = Color(0.302, 0.0, 0.976, 1.0)

@export_group("Hit Hourglass")
@export var hourglass : RigidBody3D
@export var hourglass_distance : float = 2
@export var debug_color : Color = Color(0.302, 0.619, 0.0, 1.0)
@export var impulse_magnitude_y_axis : float = 1
@export var torque_vector : Vector3 = Vector3(0, 0, 1)

var direction : Vector2
var impulse_vector : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_player_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	player_movement()
	hit_hourglass()


func hit_hourglass() -> void:
	if position.distance_to(hourglass.position) > hourglass_distance:
		set_player_color()
		return
		
	set_debug_color()
	
	if !is_hitting():
		return

	impulse_vector = hourglass.position - position
	var normalized_vector : Vector3 = impulse_vector.normalized()
	normalized_vector.y = impulse_magnitude_y_axis
	
	hourglass.hit(normalized_vector, torque_vector)
	
func player_movement() -> void:
	if player_id == 1:
		direction = Input.get_vector("left_1", "right_1", "up_1", "down_1")
	if player_id == 2:
		direction = Input.get_vector("left_2", "right_2", "up_2", "down_2")
	
	velocity.x = direction.x * speed
	velocity.z = direction.y * speed * speed_ratio_z_axis
	move_and_slide()

func set_player_color() -> void:
	if player_id == 1:
		var material = StandardMaterial3D.new()
		$MeshInstance3D.material_override = material
		material.albedo_color = player1_color
	
	if player_id == 2:
		var material = StandardMaterial3D.new()
		$MeshInstance3D.material_override = material
		material.albedo_color = player2_color
		
func set_debug_color() -> void:
		var material = StandardMaterial3D.new()
		$MeshInstance3D.material_override = material
		material.albedo_color = debug_color
		
func is_hitting() -> bool:
	if player_id == 1:
		return Input.is_action_just_released("hit_1")
	if player_id == 2:
		return Input.is_action_just_released("hit_2")
	return false
