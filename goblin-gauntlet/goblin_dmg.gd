# damage_area.gd
extends Area3D

# This function runs when something enters the area.
func _on_body_entered(body):
	print("Damage area touched: ", body.name) # Add this line

	if body.is_in_group("player"):
		print("It was the player! Dealing damage.") # Add this line
		body.take_damage(10)
