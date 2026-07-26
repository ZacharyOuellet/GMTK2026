extends CharacterBody3D

signal hit_hourglass(playerId:int)

@export var player_id : int = 1

@export_group("Controls")
@export var speed : int = 10
@export var speed_ratio_z_axis : float = 2.5

@export_group("dash")
@export var dash_speed_multiplier : float = 25
@export var afterimage_container: Node3D
@export var dash_afterimage_scene : MeshInstance3D

@export_group("Hit settings")
@export var hourglass_distance : float = 2
@export var torque_vector : Vector3 = Vector3(0, 0, 1)
@export_group("Hit settings/XZ force")
@export var min_xz_force : float = 0.5
@export var max_xz_force : float = 3
@export_group("Hit settings/Y force")
@export var min_y_force : float = 1
@export var max_y_force : float = 3

@export_group("External nodes")
@export var hourglass : RigidBody3D

@export_group("Internal nodes")
@export var charge_bar : ChargeBar

@export_group("Debug/placeholder settings")
@export var player1_color : Color =  Color(1.0, 0.847, 0.004, 1.0)
@export var player2_color : Color = Color(0.302, 0.0, 0.976, 1.0)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_player_color()

func _physics_process(_delta: float) -> void:
	player_movement()
	charge_hourglass()

func charge_hourglass() -> void:
	if position.distance_to(hourglass.position) > hourglass_distance:
		$ExclamationPoint.visible = false
		charge_bar.stop_charging() # cancel charge if it is too far
		return
	
	$ExclamationPoint.visible = true

	if !charge_bar.is_charging and player_currently_charging():
		charge_bar.start_charging()
	if player_started_charging() : 
		charge_bar.start_charging()

	if player_stopped_charging():
		var power :float = charge_bar.stop_charging()
		_on_hit_request(power)


func player_movement() -> void:
	var direction : Vector2 = Vector2.ZERO 
	var dash = false;
	if player_id == 1:
		direction = Input.get_vector("left_1", "right_1", "up_1", "down_1")
		dash = (Input.is_action_just_pressed("dash_1") or Input.is_action_just_pressed("dash_1")) and PowerUpManager.is_power_up_available(player_id, PowerUpManager.PowerUpType.DASH)
	if player_id == 2:
		direction = Input.get_vector("left_2", "right_2", "up_2", "down_2")
		dash = (Input.is_action_just_pressed("dash_2") or Input.is_action_just_pressed("dash_2")) and PowerUpManager.is_power_up_available(player_id, PowerUpManager.PowerUpType.DASH)



	velocity.x = direction.x * speed if !dash else direction.x * speed * dash_speed_multiplier
	velocity.z = direction.y * speed * speed_ratio_z_axis if !dash else direction.y * speed * speed_ratio_z_axis * dash_speed_multiplier
	if dash:
		PowerUpManager.reset_power_up(player_id, PowerUpManager.PowerUpType.DASH)
		_generate_dash_afterimage(velocity)
	move_and_slide()

func _generate_dash_afterimage(velocity: Vector3) -> void:
	var current_position = global_transform.origin
	var offset = velocity.normalized()
	for i in range(1, 5):
		if i % 2 == 0:
			continue

		var dash_af = dash_afterimage_scene.duplicate()
		dash_af.global_transform.origin = current_position + Vector3(offset.x * i, 1 , offset.z * i * speed_ratio_z_axis)
		afterimage_container.add_child(dash_af)
		get_tree().create_timer(.07 * i).timeout.connect(dash_af.queue_free.bind())


func set_player_color() -> void:
	if player_id == 1:
		var material = StandardMaterial3D.new()
		$MeshInstance3D.material_override = material
		material.albedo_color = player1_color
	
	if player_id == 2:
		var material = StandardMaterial3D.new()
		$MeshInstance3D.material_override = material
		material.albedo_color = player2_color
		
		

func player_started_charging() -> bool:
	if player_id == 1:
		return Input.is_action_just_pressed("hit_1")
	if player_id ==2 :
		return Input.is_action_just_pressed("hit_2")
	return false
	

func player_currently_charging() -> bool:
	if player_id == 1:
		return Input.is_action_pressed("hit_1")
	if player_id ==2 :
		return Input.is_action_pressed("hit_2")
	return false
	

func player_stopped_charging() -> bool:
	if player_id == 1:
		return Input.is_action_just_released("hit_1")
	if player_id == 2:
		return Input.is_action_just_released("hit_2")
	return false
	

func _on_hit_request(power: float):
	var horizontal_direction : Vector3 = (hourglass.position - position).normalized()
	var hit_vector : Vector3 = horizontal_direction * lerp(min_xz_force, max_xz_force, power)
	hit_vector.y =  lerp(min_y_force, max_y_force, power)
	hit_vector.z *= speed_ratio_z_axis
	hourglass.hit(hit_vector, torque_vector)
	GlobalJuiceMachine.request_shake(power, 0.2)
	hit_hourglass.emit(player_id)
