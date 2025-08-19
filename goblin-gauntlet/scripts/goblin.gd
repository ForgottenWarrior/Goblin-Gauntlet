extends CharacterBody3D

# Preload the gem scene so the goblin knows what to drop on death.
const EXPERIENCE_GEM_SCENE = preload("res://scenes/experience_gem.tscn")
const GOLD_COIN_SCENE = preload("res://scenes/gold_coin.tscn") 

# These variables can be changed in the Godot editor's Inspector.
@export var health: int = 10	# goblin health
@export var move_speed: float = 3.0	# goblin movement
@export var score_value: int = 10	
@export var gold_drop_chance: float = 0.50 # A 50% chance to drop gold

# This will hold a reference to the player node.
var player: Node3D = null

func _physics_process(_delta):
	# This block robustly finds the player.
	# If we don't have a valid reference, it tries to find one.
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		# If the player still can't be found, do nothing this frame.
		if not is_instance_valid(player):
			return

	# If we have a valid player, execute the chase logic.
	var direction = (player.global_position - self.global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

func take_damage(damage_amount: int):
	health -= damage_amount
	print("Goblin took ", damage_amount, " damage, ", health, " HP remaining.")

	if health <= 0:
		GameManager.add_score(score_value)

		# Drop an experience gem
		if EXPERIENCE_GEM_SCENE:
			var gem = EXPERIENCE_GEM_SCENE.instantiate()
			get_tree().get_root().add_child(gem)
			gem.global_position = self.global_position

		# Check if we should also drop a gold coin
		if randf() < gold_drop_chance:
			var coin = GOLD_COIN_SCENE.instantiate()
			get_tree().get_root().add_child(coin)
			coin.global_position = self.global_position

		queue_free()
