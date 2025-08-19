extends Area3D

@export var damage = 5

# A list to keep track of enemies currently inside the axe's area.
var overlapping_enemies = []

func _on_timer_timeout():
	# When the timer fires, damage every enemy in the list.
	for enemy in overlapping_enemies:
		if is_instance_valid(enemy):
			enemy.take_damage(damage)

func _on_body_entered(body):
	# When an enemy enters the area, add it to our list.
	if body.is_in_group("enemy"):
		if not overlapping_enemies.has(body):
			overlapping_enemies.append(body)

func _on_body_exited(body):
	# When an enemy leaves the area, remove it from our list.
	if body.is_in_group("enemy"):
		if overlapping_enemies.has(body):
			overlapping_enemies.erase(body)
