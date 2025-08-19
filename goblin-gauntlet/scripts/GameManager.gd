extends Node

var current_score: int = 0

# A signal to tell the HUD when the score has changed.
signal score_updated(new_score)

func add_score(amount: int):
	current_score += amount
	score_updated.emit(current_score)
	print("Score is now: ", current_score)

# A function to reset the score when a new game starts.
func reset():
	current_score = 0
	score_updated.emit(current_score)
