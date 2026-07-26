extends ProgressBar

@export var PlayerID: int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var potential_value = PowerUpManager.get_power_up_percentage(PlayerID, PowerUpManager.PowerUpType.DASH) * 100
	value = 101 if PowerUpManager.is_power_up_available(PlayerID, PowerUpManager.PowerUpType.DASH) else potential_value