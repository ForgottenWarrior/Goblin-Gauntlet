extends Button

# This signal will be sent out when the card is clicked.
signal upgrade_selected(upgrade_key)

var my_upgrade_key: String

# This function will be called to set the text on the card.
func set_upgrade_data(upgrade_key, upgrade_info):
	my_upgrade_key = upgrade_key
	$MarginContainer/VBoxContainer/TitleLabel.text = upgrade_info.title
	$MarginContainer/VBoxContainer/DescriptionLabel.text = upgrade_info.description

# When the button is pressed, emit the signal.
func _on_pressed():
	emit_signal("upgrade_selected", my_upgrade_key)
