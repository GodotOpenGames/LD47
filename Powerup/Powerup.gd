extends Area2D



func _on_Powerup_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.powerup_jump()
		queue_free()
