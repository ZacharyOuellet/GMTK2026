extends CharacterBody3D

@export_group("Player")
@export var player_id : int = 1
@export var speed : int = 10
@export var speed_ratio_z_axis : int = 2.5
@export var player1_color : Color =  Color(1.0, 0.847, 0.004, 1.0)
@export var player2_color : Color = Color(0.302, 0.0, 0.976, 1.0)
@export var charging_bar : ProgressBar

@export_group("Hit Hourglass")
@export var hourglass : RigidBody3D
@export var hourglass_distance : float = 2
@export var debug_color : Color = Color(0.302, 0.619, 0.0, 1.0)
@export var impulse_magnitude_y_axis : float = 1
@export var torque_vector : Vector3 = Vector3(0, 0, 1)
@export var sin_period : float = 0.5
@export var sin_mag : float = 50
@export var min_xz_force : float = 0.5
@export var max_xz_force : float = 3
@export var min_y_force : float = 1
@export var max_y_force : float = 3

var is_charging : bool
var charge_start_time : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_player_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	player_movement()
	charge_hourglass()

func charge_hourglass() -> void:
	if position.distance_to(hourglass.position) > hourglass_distance:
		set_player_color()
		return
		
	set_debug_color()
		
	if is_player_charging() and !is_charging : 
		is_charging = true
		charge_start_time = Time.get_ticks_msec()
		$Sprite3D.visible = true
		
	if is_charging:
		charging_bar.value = calculate_force_magnitude(Time.get_ticks_msec() - charge_start_time)
		
	if is_hitting():
		is_charging = false
		var charge_magnitude = calculate_force_magnitude(Time.get_ticks_msec() - charge_start_time)
		var impulse_vector : Vector3 = hourglass.position - position
		var hit_vector : Vector3 = impulse_vector.normalized() * lerp(min_xz_force, max_xz_force, charge_magnitude/100)
		hit_vector.y =  lerp(min_y_force, max_y_force, charge_magnitude/100)
		hourglass.hit(hit_vector, torque_vector)
		charging_bar.value = 0
		$Sprite3D.visible = false

func calculate_force_magnitude(charging_time : float) -> float:
	return (sin(charging_time / 1000 * sin_period - PI/2) + 1) * sin_mag

func player_movement() -> void:
	var direction : Vector2 = Vector2.ZERO 
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


func is_player_charging() -> bool:
	if player_id == 1:
		return Input.is_action_pressed("hit_1")
	if player_id ==2 :
		return Input.is_action_pressed("hit_2")
	return false

 
func is_hitting() -> bool:
	if player_id == 1:
		return Input.is_action_just_released("hit_1")
	if player_id == 2:
		return Input.is_action_just_released("hit_2")
	return false
