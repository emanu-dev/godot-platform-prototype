extends Node

func _process(delta):
	if Input.is_action_pressed("restart"):
		restart_game()
		

func restart_game():
	get_tree().reload_current_scene()

func _on_Player_player_dead():
	restart_game()
