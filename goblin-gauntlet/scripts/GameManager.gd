extends Node

var current_score: int = 0
var current_gold: int = 0

# Define the save file path.
const SAVE_FILE_PATH = "user://savegame.dat"

signal score_updated(new_score)
signal gold_updated(new_gold)

# _ready() runs once when the game starts.
func _ready():
	load_gold()

# _notification() is a special function that can detect when the game is closing.
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_gold()

func add_score(amount: int):
	current_score += amount
	score_updated.emit(current_score)
	print("Score is now: ", current_score)

func add_gold(amount: int):
	current_gold += amount
	gold_updated.emit(current_gold)
	print("Collected ", amount, " gold! Total: ", current_gold)

func reset():
	current_score = 0
	# We don't reset gold anymore, as it's persistent.
	score_updated.emit(current_score)
	# We still emit the gold signal to update the UI on a new run.
	gold_updated.emit(current_gold)

func save_gold():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file:
		save_file.store_var(current_gold)
		print("Game saved. Gold: ", current_gold)

func load_gold():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if save_file:
			# The file is read line by line. Since we only saved one variable, we only read one.
			current_gold = save_file.get_var()
			print("Game loaded. Gold: ", current_gold)

	# Update the UI with the loaded gold amount.
	gold_updated.emit(current_gold)
