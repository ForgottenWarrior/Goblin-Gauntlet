extends ColorRect

func _on_resume_button_pressed():
	get_tree().call_group("gameplay", "set_process_mode", Node.PROCESS_MODE_ALWAYS)
	queue_free()

func _on_quit_button_pressed():
	# Instead of quitting, this now opens the confirmation dialog.
	$ConfirmationDialog.popup_centered()

func _on_confirmation_dialog_confirmed():
	# This function only runs when "Yes" is clicked in the dialog.
	get_tree().quit()
