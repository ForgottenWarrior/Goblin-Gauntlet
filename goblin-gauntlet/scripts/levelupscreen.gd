extends ColorRect

# This signal will send the chosen upgrade key back to the player.
signal upgrade_selected(upgrade_key)

const UPGRADE_CARD_SCENE = preload("res://scences/upgrade_card.tscn")

# This function is called by the player to set up the screen.
func initialize_options(upgrades):
	# Create a list of the keys from the upgrade dictionary.
	var available_keys = upgrades.keys()
	available_keys.shuffle() # Randomize the list.

	# Create a card for the first 3 upgrades in the random list.
	var choice_count = min(available_keys.size(), 3)
	for i in range(choice_count):
		var upgrade_key = available_keys[i]
		var upgrade_info = upgrades[upgrade_key]
		
		var card = UPGRADE_CARD_SCENE.instantiate()
		# Add the new card inside our VBoxContainer.
		$VBoxContainer.add_child(card)
		
		# Set the card's text.
		card.set_upgrade_data(upgrade_key, upgrade_info)
		
		# Connect the card's signal to a new function in this script.
		card.upgrade_selected.connect(_on_upgrade_card_selected)

# This function runs as soon as the UI is created.
func _ready():
	get_tree().paused = true

# This function runs when any of the cards are clicked.
func _on_upgrade_card_selected(upgrade_key):
	# Send the chosen key up to the player.
	emit_signal("upgrade_selected", upgrade_key)
	
	# Unpause the game and remove the UI.
	get_tree().paused = false
	queue_free()
