extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameManager.add_gold(1) # This coin is worth 1 gold
		queue_free()
