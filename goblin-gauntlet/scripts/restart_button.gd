extends ColorRect

func _on_restart_button_pressed():
	# First, unpause the game so the new scene runs correctly.
	get_tree().paused = false
	
	# Second, reload the current level.
	get_tree().reload_current_scene()
	
	# Finally, tell the Game Over screen to delete itself.
	queue_free()
