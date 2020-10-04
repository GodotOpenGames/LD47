extends KinematicBody2D

var walk_speed = 350
var start_jump_force = 800
var power_jump_force = 1100
var jump_force = 0
var gravity = 50
var max_fall_speed = 1000

var velocity = Vector2()
var facing_right = true

var lift_object = null
var is_lifting = false
var is_dropping = false
var door = null

func _ready() -> void:
	reset_stats()
	
func _physics_process(_delta: float) -> void:
	var walk_dir = 0
	
	# Don't move player during lift or drop animation
	if !$LiftTween.is_active():
		# Check if player is walking
		if Input.is_action_pressed("walk_left"):
			walk_dir -= 1
		if Input.is_action_pressed("walk_right"):
			walk_dir += 1
		velocity.x = walk_dir * walk_speed
		var _ignore = move_and_slide(velocity, Vector2.UP)
	
		# Handle gravity and jumping
		velocity.y += gravity
		if is_on_floor():
			velocity.y = min(velocity.y, 5)
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
				$JumpSound.play()
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
		if Input.is_action_just_pressed("door"):
			try_enter_door()
	
	# Set animation based on what player is doing right now
	var anim_name = get_animation_name(walk_dir)
	$AnimatedSprite.play(anim_name)
	
	# Make player face the direction of last movement
	update_face_direction(walk_dir)
	
func update_face_direction(walk_dir):
	if walk_dir > 0 && !facing_right:
		facing_right = true
		$AnimatedSprite.flip_h = false
		$RayCastFront.rotation_degrees = -90
		if lift_object != null:
			lift_object.get_node("Sprite").flip_h = false
	elif walk_dir < 0 and facing_right:
		facing_right = false
		$AnimatedSprite.flip_h = true
		$RayCastFront.rotation_degrees = 90
		if lift_object != null:
			lift_object.get_node("Sprite").flip_h = true

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
	# Check for object in front of the player
	var object = $RayCastFront.get_collider()
	var pickType = "front"
	
	# If nothing pickable, check for object underneath the player
	if object == null || !object.is_in_group("Pickables"):
		object = $RayCastBottom.get_collider()
		pickType = "below"
		
	# If still nothing pickable, bail out
	if object == null || !object.is_in_group("Pickables"):
		return

	# Otherwise, pick up the object
	lift_object = object
	
	# Turn off picked object's physics so it doesn't fall down into the player
	lift_object.pickup()

	# Animation varies based on picking up from front or below
	if pickType == "front":
		# Move object directly to lift position above player's head
		$LiftTween.interpolate_property(object, "global_position", object.global_position, $LiftPosition.global_position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		# Object and player switch positions
		$LiftTween.interpolate_property(object, "position", object.position, position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$LiftTween.interpolate_property(self, "position", position, object.position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		
	# Start the lifting animation
	is_lifting = true
	$LiftTween.start()
	$PickupSound.play()

func drop():
	# Place the object at the player's feet and the player ends up standing atop it
	# i.e. they switch places
	$LiftTween.interpolate_property(lift_object, "position", lift_object.position, position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$LiftTween.interpolate_property(self, "position", position, lift_object.position, 0.12, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	# Start the drop animation
	is_dropping = true
	$LiftTween.start()
	$PickupSound.play()  # TODO: different sounds for pickup/drop

func try_enter_door():
	if door == null:
		return
		
	if door.locked:
		try_unlock_door()
		return
	
	# If player is carrying an object, detach it from the scene so it
	# doesn't get destroyed when the room changes
	if lift_object != null:
		lift_object.get_parent().remove_child(lift_object)
		
	get_parent().change_room(door.destination)
	$DoorSound.play()
	
	# Attach the object to the new room
	if lift_object != null:
		get_parent().current_room.add_child(lift_object)	

func try_unlock_door():
	# Need a key to go through locked doors
	if lift_object != null && lift_object.name.find("Key") > -1:
		$UnlockDoorSound.play()
		door.unlock()
		lift_object.queue_free()
		lift_object = null
	else:
		$LockedDoorSound.play()

func _on_LiftTween_tween_all_completed() -> void:
	# If the pickup animation completed
	if is_lifting:
		is_lifting = false
		
		# To handle the case where the picked up object had other objects
		# resting on top of it, notify all OTHER objects in the scene to
		# turn on their physics
		for object in get_tree().get_nodes_in_group("Pickables"):
			if object != lift_object:
				object.try_falling()
	
	# If the dropping animation completed
	if is_dropping:
		is_dropping = false
		
		# Notify the object it's being dropped
		lift_object.drop()

		# Stop tracking the picked object
		lift_object = null

func powerup_jump():
	jump_force = power_jump_force
	$PowerupSound.play()
	
func reset_stats():
	$SpawnSound.play()
	# So far, jump force is the only thing that changes
	jump_force = start_jump_force
