extends Control


func _ready() -> void:
	print("PLAYER ", LevelManager.winner_id, " WON THE GAME")
	# TODO do something else than just print the winner

func _on_replay():
	LevelManager.start_game()