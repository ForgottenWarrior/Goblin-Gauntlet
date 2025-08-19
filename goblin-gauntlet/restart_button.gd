extends ColorRect

func _on_restart_button_pressed():
	# First, unpause the game.
	get_tree().paused = false
	# Then, reload the current level scene.
	get_tree().reload_current_scene()
