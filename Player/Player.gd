extends KinematicBody2D

var walk_speed = 350
var jump_force = 800
var gravity = 50
var max_fall_speed = 1000

var velocity = Vector2()
var facing_right = true
var lift_object = null

func _physics_process(delta: float) -> void:
	var walk_dir = 0
	
	# Don't move player during lift animation
	if !$LiftTween.is_active():
		# Check if player is walking
		if Input.is_action_pressed("walk_left"):
			walk_dir -= 1
		if Input.is_action_pressed("walk_right"):
			walk_dir += 1
		velocity.x = walk_dir * walk_speed
		move_and_slide(velocity, Vector2.UP)
	
		# Handle gravity and jumping
		velocity.y += gravity
		if is_on_floor():
			if velocity.y > 10:
				velocity.y = 10
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
		else:
			velocity.y = min(velocity.y, max_fall_speed)

		# Can only pickup or drop while on the ground
		if is_on_floor():
			# Try to pickup something, or drop what they've already got
			if Input.is_action_just_pressed("pickup"):
				if lift_object != null:
					drop()
				else:
					try_pickup()
	
		# If player is lifting something, and the initial lift animation is done,
		# keep it at the lift position every frame
		if lift_object != null:
			lift_object.position = $LiftPosition.global_position
	
	# Set animation based on what player is doing right now
	var anim_name = get_animation_name(walk_dir)
	$AnimatedSprite.play(anim_name)
	
	# Make player face the direction of last movement
	if walk_dir > 0 && !facing_right:
		facing_right = true
		$AnimatedSprite.flip_h = false
		$DropPosition.position.x *= -1
	elif walk_dir < 0 and facing_right:
		facing_right = false
		$AnimatedSprite.flip_h = true
		$DropPosition.position.x *= -1

func get_animation_name(walk_dir):
	var name = "idle"
	if is_on_floor():
		if walk_dir != 0:
			name = "walk"
	else:
		if velocity.y < 0:
			name = "jump"
		else:
			name = "fall"
		
	# Do you even life bro?
	if lift_object != null:
		name += "_lift"
	return name

func try_pickup():
	var object = null
	# First check for a box in direction they're facing
	if facing_right:
		object = $RayCastRight.get_collider()
	else:
		object = $RayCastLeft.get_collider()
		
	# If nothing pickable, check for a box underneath the player
	if object == null || !object.is_in_group("Pickables"):
		object = $RayCastBottom.get_collider()
		
	# If still nothing pickable, bail out
	if object == null || !object.is_in_group("Pickables"):
		return false

	# Pick the object up
	lift_object = object
	# Turn off the object's collision detection so it doesn't crush the player
	object.get_node("CollisionShape2D").disabled = true
	# Tween object position to lift position above player's head
	$LiftTween.interpolate_property(object, "position", object.position, $LiftPosition.global_position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LiftTween.start()

func drop():
	# Place the object in front of the player
	$LiftTween.interpolate_property(lift_object, "position", lift_object.position, $DropPosition.global_position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LiftTween.start()
	# Turn the object's collision detection back on
	lift_object.get_node("CollisionShape2D").disabled = false
	lift_object = null
