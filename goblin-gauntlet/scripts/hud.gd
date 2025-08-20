extends CanvasLayer
func _ready():
	# Connect to the global GameManager's signal.
	GameManager.score_updated.connect(_on_score_updated)
# This function will be called by the player to update the health bar.
func set_health(current_health: int, max_health: int):
	# We access the TextureProgressBar using its name ($HealthBar)
	var health_bar = $HealthBar

	# Set the bar's maximum and current values
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# This function updates the XP bar.
func set_experience(current_xp: int, xp_to_next_level: int):
	var xp_bar = $XpBar
	xp_bar.max_value = xp_to_next_level
	xp_bar.value = current_xp
	
func _on_score_updated(new_score: int):
	$ScoreLabel.text = "Score: " + str(new_score)
	
func _process(_delta):
	$FpsLabel.text = "FPS: " + str(Engine.get_frames_per_second())
