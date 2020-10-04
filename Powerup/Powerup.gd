extends Area2D

var angle = 0

func _process(delta: float) -> void:
	angle += delta
	$Sprite.position.y = 1 * sin(angle * 3)
	
func _on_Powerup_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.powerup_jump()
		queue_free()
		
		# Advance story - collect jump shoes
		if body.story < 4:
			body.story = 4
