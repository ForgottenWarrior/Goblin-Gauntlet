extends Node3D

## The enemy scene we want to spawn. We'll set this in the editor.
@export var enemy_scene: PackedScene

## How far from the player the enemies should spawn.
@export var spawn_radius: float = 20.0

func _on_timer_timeout():
	# First, find the player.
	var player = get_tree().get_first_node_in_group("player")

	# If the player doesn't exist for some reason, do nothing.
	if not is_instance_valid(player):
		return

	# 1. Calculate a random direction.
	var random_direction = Vector3.RIGHT.rotated(Vector3.UP, randf_range(0, TAU))

	# 2. Determine the spawn position in a circle around the player.
	var spawn_position = player.global_position + random_direction * spawn_radius

	# 3. Make sure we have a valid enemy scene to spawn.
	if not enemy_scene:
		return

	# 4. Create a new enemy instance.
	var new_enemy = enemy_scene.instantiate()

	# 5. Add the enemy to the same level the spawner is in.
	get_parent().add_child(new_enemy)

	# 6. Set the enemy's position.
	new_enemy.global_position = spawn_position
