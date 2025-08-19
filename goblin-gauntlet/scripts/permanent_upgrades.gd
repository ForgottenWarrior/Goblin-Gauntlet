extends Control

func _ready():
	# Display the current gold when the screen opens.
	$GoldLabel.text = "Gold: " + str(GameManager.current_gold)

	# We can also connect to the signal to keep it updated.
	GameManager.gold_updated.connect(_on_gold_updated)

func _on_gold_updated(new_gold):
	$GoldLabel.text = "Gold: " + str(new_gold)

func _on_purchase_health_button_pressed():
	# We will add the purchase and save logic in the next step.
	print("Purchase health upgrade button pressed!")

func _on_back_button_pressed():
	# Go back to the main menu.
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn") # Adjust path if needed
