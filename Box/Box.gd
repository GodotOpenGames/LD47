extends StaticBody2D

var gravity = 50  # same as the player
var max_fall_speed = 1000
var velocity = Vector2()
var carried = false

func _physics_process(delta: float) -> void:
	if !carried:
		pass
#		print("not carried, falling")
#		move_and_collide(velocity * delta)
#
#		# Handle gravity
#		velocity.y += gravity
#		if is_on_floor():
#			velocity.y = min(velocity.y, 10)
#		else:
#			velocity.y = min(velocity.y, max_fall_speed)
##		print("velocity: " + str(velocity))
