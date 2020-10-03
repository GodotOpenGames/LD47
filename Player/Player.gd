extends KinematicBody2D

var walk_speed = 350
var jump_force = 800
var gravity = 50
var max_fall_speed = 1000

var velocity = Vector2()
var facing_right = true
var lift_object = null
var on_door = null

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
			velocity.y = min(velocity.y, 5)
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
		else:
			velocity.y = min(velocity.y, max_fall_speed)

		# Try to pickup something, or drop what they've already got
		if Input.is_action_just_pressed("pickup"):
			if lift_object != null:
				drop()
			else:
				try_pickup()
	
		# If player is lifting something, and the initial lift animation is done,
		# keep it at the lift position every frame
		if lift_object != null:
			lift_object.global_position = $LiftPosition.global_position
			
		# Try to enter a door
		if Input.is_action_just_pressed("door") && on_door != null:
			enter_door(on_door)
	
	# Set animation based on what player is doing right now
	var anim_name = get_animation_name(walk_dir)
	$AnimatedSprite.play(anim_name)
	
	# Make player face the direction of last movement
	if walk_dir > 0 && !facing_right:
		facing_right = true
		$AnimatedSprite.flip_h = false
	elif walk_dir < 0 and facing_right:
		facing_right = false
		$AnimatedSprite.flip_h = true

func get_animation_name(walk_dir):
	if is_on_floor():
		if walk_dir == 0:
			return "idle"
		else:
			return "walk"
	else:
		if velocity.y < 0:
			return "jump"
		else:
			return "fall"

func try_pickup():
	# Check for a box underneath the player
	var object = $RayCastBottom.get_collider()
		
	# If nothing pickable, bail out
	if object == null || !object.is_in_group("Pickables"):
		return

	# Pick the object up
	lift_object = object
#	# Turn off the object's collision detection so it doesn't crush the player
	object.get_node("CollisionShape2D").disabled = true
#	# Tell the object it's being carried so it won't update itself
#	object.carried = true
#	# Tween object position to lift position above player's head, also
#	# move player down to where the object was resting
	$LiftTween.interpolate_property(object, "position", object.position, position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LiftTween.interpolate_property(self, "position", position, object.position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LiftTween.start()

func drop():
	# Place the object at the player's feet and the player ends up standing atop it
	# i.e. they switch places
	$LiftTween.interpolate_property(lift_object, "position", lift_object.position, position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LiftTween.interpolate_property(self, "position", position, lift_object.position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LiftTween.start()
	# Turn the object's collision detection back on
	lift_object.get_node("CollisionShape2D").disabled = false
	# Tell the object it's no longer carried so it will update (fall)
	lift_object.carried = false
	lift_object = null

func enter_door(destination):
	# If player is carrying an object, detach it from the scene so it
	# doesn't get destroyed when the room changes
	if lift_object != null:
		get_parent().current_room.remove_child(lift_object)
		
	get_parent().change_room(destination)
	
	# Attach the object to the new room
	if lift_object != null:
		get_parent().current_room.add_child(lift_object)	
