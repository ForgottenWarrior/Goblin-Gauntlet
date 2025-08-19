extends Area3D
const EXPERIENCE_GEM_SCENE = preload("res://scences/experience_gem.tscn")
var damage = 8 # Based on your spreadsheet for Arcane Bolt Lvl 1
var speed = 10.0

func _process(delta):
	# Move forward along the -Z axis.
	global_position += -transform.basis.z * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		# Instead of destroying the enemy directly...
		# ...call its take_damage function.
		body.take_damage(damage)

		# The missile still destroys itself on impact.
		queue_free()
