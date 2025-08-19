extends ColorRect

func _on_resume_button_pressed():
	# Unpause all the gameplay nodes.
	get_tree().call_group("gameplay", "set_process_mode", Node.PROCESS_MODE_ALWAYS)
	# Remove the pause menu.
	queue_free()

func _on_quit_button_pressed():
	# Quit the game completely.
	get_tree().quit()
