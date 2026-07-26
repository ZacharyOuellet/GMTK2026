extends Node

@export var start_time_bank: float = 20

# TODO change menu_scene
const menu_scene = preload("res://scene/ui/win_scene.tscn")
const gameScene = preload("res://scene/MainGame.tscn")
const win_scene = preload("res://scene/ui/win_scene.tscn")

var winner_id;

func start_game():
	get_tree().change_scene_to_packed(gameScene)

func go_to_win_game(new_winner_id: int):
	winner_id = new_winner_id
	get_tree().change_scene_to_packed(win_scene)
