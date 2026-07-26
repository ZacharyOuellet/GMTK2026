extends Control

@export var materials_override:Dictionary[String, Material]

func _ready() -> void:
	print("PLAYER ", LevelManager.winner_id, " WON THE GAME")
	var color = "Red" if LevelManager.winner_id ==1 else "Blue"
	$Result.text = color + " player wins!"
	%animated_model.material = materials_override[color]
	# TODO do something else than just print the winner

func _on_replay():
	LevelManager.start_game()
