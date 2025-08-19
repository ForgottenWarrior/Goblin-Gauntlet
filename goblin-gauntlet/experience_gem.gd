extends Area3D

func _on_body_entered(body):
	# Check if the body that entered is the player.
	if body.is_in_group("player"):
		# Call the player's function and destroy the gem.
		body.add_experience(1) # This gem is worth 1 XP
		queue_free()
