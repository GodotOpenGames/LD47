extends KinematicBody2D

# Copied from the Player
var gravity = 50
var max_fall_speed = 1000

var vel_y = 0

var falling = false

func pickup():
	# This object was picked up by the player so stop it from falling on
	# the player's head
	stop_falling()
	
	# Also stop checking collisions so other objects won't land on it
	# while being carried
	$CollisionShape2D.disabled = true
	
func drop():
	# Turn the object's collision detection back on
	$CollisionShape2D.disabled = false
	
	# Check if the object was dropped in mid-air
	try_falling()

func stop_falling():
	falling = false
	vel_y = 0
	
func try_falling():
	# Assume we're falling, until proven otherwise
	falling = true
	
	# Check what's below the box
	var object = $RayCastMid.get_collider()
	if object == null:
		object = $RayCastRight.get_collider()
	if object == null:
		object = $RayCastLeft.get_collider()
		
	if object != null:
		if object.name == "TileMap": 
			# Landed on tilemap, that's stable
			stop_falling()
		elif "falling" in object && !object.falling:
			# Landed on another object that's not falling, that's stable
			stop_falling()

func _process(delta: float) -> void:
	# color stuff to help me debug
#	if falling:
#		$Sprite.modulate = Color(1, 0, 0, 1)
#	else:
#		$Sprite.modulate = Color(1, 1, 1, 1)
	pass

func _physics_process(delta: float) -> void:
	if falling:
		# Move straight down with gravity
		vel_y += gravity
		vel_y = min(vel_y, max_fall_speed)
		var collision = move_and_collide(Vector2(0, vel_y * delta))
		
		# If it lands on the player, try to move back up to give the player
		# some room to get out
		if collision != null && collision.collider.name == "Player":
			move_and_collide(Vector2(0, -1))
		
		# Check if we're still falling
		try_falling()
