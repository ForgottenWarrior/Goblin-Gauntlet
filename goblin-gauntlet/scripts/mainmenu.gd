extends Control

func _ready():
	# Connect to the GameManager's signal.
	GameManager.gold_updated.connect(_on_gold_updated)
	# Ask the GameManager for the current gold amount immediately.
	GameManager.gold_updated.emit(GameManager.current_gold)

func _on_gold_updated(new_gold):
	$GoldLabel.text = "Gold: " + str(new_gold)
	
func _on_start_game_button_pressed():
	# This function loads your main game level.
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_quit_button_pressed():
	# This function closes the application.
	get_tree().quit()
	
func _on_upgrades_button_pressed():
	get_tree().change_scene_to_file("res://scenes/upgrades_menu.tscn") 
