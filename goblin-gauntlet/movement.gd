extends CharacterBody3D

const LEVEL_UP_SCREEN = preload("res://level_up_screen.tscn")
const MAGIC_MISSILE_SCENE = preload("res://magic_missile.tscn")
const SPINNING_AXE_SCENE = preload("res://spinning_axe.tscn")
const GAME_OVER_SCREEN = preload("res://game_over_screen.tscn")

@export var MOVE_SPEED: float = 5.0
@export var health: int = 100
@export var max_health: int = 100

var missile_speed: float = 10.0
var current_xp: int = 0
var xp_to_next_level: int = 5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var axe_pivot_speed = 2.0 # Radians per second

var upgrades_pool = {
	"player_speed": {
		"title": "Swift Soles",
		"description": "Increases your movement speed by 10%."
	},
	"fire_rate": {
		"title": "Rapid Fire",
		"description": "Increases missile fire rate by 15%."
	},
	"missile_speed": {
		"title": "Missile Velocity",
		"description": "Your missiles fly 20% faster."
	},
	# ADD THIS NEW UPGRADE
	"spinning_axe": {
		"title": "Spinning Axe",
		"description": "An axe orbits you, damaging nearby enemies."
	}
}

signal health_updated(current_health, max_health)
signal experience_updated(current_xp, xp_to_next_level)

func _ready():
	# Emit the signal when the player first spawns.
	health_updated.emit(health, max_health)
	experience_updated.emit(current_xp, xp_to_next_level)
	
func _physics_process(delta):
	var new_velocity = velocity
	if not is_on_floor():
		new_velocity.y -= gravity * delta
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		new_velocity.x = direction.x * MOVE_SPEED
		new_velocity.z = direction.z * MOVE_SPEED
	else:
		new_velocity.x = move_toward(velocity.x, 0, MOVE_SPEED)
		new_velocity.z = move_toward(velocity.z, 0, MOVE_SPEED)
	velocity = new_velocity
	move_and_slide()
	$AxePivot.rotate_y(axe_pivot_speed * delta)

func _on_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty():
		return
	var closest_enemy = null
	var closest_distance = 9999.0
	for enemy in enemies:
		if is_instance_valid(enemy):
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy
	if is_instance_valid(closest_enemy):
		var missile = MAGIC_MISSILE_SCENE.instantiate()
		get_tree().get_root().add_child(missile)
		missile.global_position = self.global_position
		missile.transform = missile.transform.looking_at(closest_enemy.global_position, Vector3.UP)
		
func add_experience(amount: int):
	current_xp += amount
	print("Gained ", amount, " XP! Total: ", current_xp, "/", xp_to_next_level)
	experience_updated.emit(current_xp, xp_to_next_level)
	if current_xp >= xp_to_next_level:
		level_up()

func level_up():
	print("LEVEL UP!")
	var level_up_instance = LEVEL_UP_SCREEN.instantiate()
	get_tree().get_root().add_child(level_up_instance)
	level_up_instance.initialize_options(upgrades_pool)
	level_up_instance.upgrade_selected.connect(_on_upgrade_selected)
	current_xp = 0
	xp_to_next_level = int(xp_to_next_level * 1.6)
	experience_updated.emit(current_xp, xp_to_next_level)

func _on_upgrade_selected(upgrade_key):
	print("Player chose upgrade: ", upgrade_key)

	if upgrade_key == "player_speed":
		MOVE_SPEED *= 1.10

	elif upgrade_key == "fire_rate":
		$Timer.wait_time *= 0.85

	elif upgrade_key == "missile_speed":
		missile_speed *= 1.20

	# ADD THIS BLOCK
	elif upgrade_key == "spinning_axe":
		var axe = SPINNING_AXE_SCENE.instantiate()
		# Add the axe as a child of the pivot, not the player.
		$AxePivot.add_child(axe)
		# Position the axe away from the center so it has an orbit.
		axe.position.z = -5

func take_damage(damage_amount: int):
	health -= damage_amount
	print("Player took ", damage_amount, " damage, ", health, " HP remaining.")

	# Emit the signal with the new health values.
	health_updated.emit(health, max_health)

	# Inside the take_damage function...
	if health <= 0:
		print("GAME OVER")
	# Instead of quitting, show the game over screen and pause.
		get_tree().paused = true
		var game_over_instance = GAME_OVER_SCREEN.instantiate()
		get_tree().get_root().add_child(game_over_instance)
	# We can also hide the player to prevent them from firing.
		self.hide()
