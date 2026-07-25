extends Node3D

# How quickly to move through the noise
@export var NOISE_SHAKE_SPEED: float = 30.0
@export var STRENGTH_SCALE: float = 100

@onready var rand = RandomNumberGenerator.new()

@onready var noise = FastNoiseLite.new()

# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0
var shake_strength: float = 0.0

var intensity: float = 0.0
var duration_ms: float = 1
var end_time: float = 0.0

var initial_pos: Vector3

func _ready() -> void:
	initial_pos = position
	rand.randomize()
	# Randomize the generated noise
	noise.seed = rand.randi()
	GlobalJuiceMachine.shake_requested.connect(apply_noise_shake)

func apply_noise_shake(intensity, duration) -> void:
	shake_strength = intensity
	self.duration_ms = duration * 1000
	self.intensity = intensity
	end_time = Time.get_ticks_msec() + duration_ms

func _process(delta: float) -> void:
	# Fade out the intensity over time
	var progress := 1 - (end_time - Time.get_ticks_msec()) / duration_ms
	print("PROG:", progress)
	if progress >= 1:
		position = initial_pos
		return
	shake_strength = lerp(intensity, 0.0, progress)
	print("Strength: ", shake_strength)
	print("initial: ", initial_pos)
	position = initial_pos
	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	var offset := get_noise_offset(delta)
	print(offset)
	position += offset
	print("offseted: ", position)


func get_noise_offset(delta: float) -> Vector3:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise

	return Vector3(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength,
		noise.get_noise_2d(-100, noise_i) * shake_strength,
	)
