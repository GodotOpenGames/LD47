extends Area2D

#export var super = false
#var hue = 0

var angle = 0

#func _ready() -> void:
#	$SparkleSprite.visible = super
	
func _process(delta: float) -> void:
	# Only the super shoes sparkle
#	if super:
#		hue += delta
#		var color = Color.from_hsv(hue, 1, 1, 1)
#		$SparkleSprite.modulate = color

	angle += delta
	$Sprite.position.y = 1 * sin(angle * 3)
	
func _on_Powerup_body_entered(body: Node) -> void:
	if body.name == "Player":
#		var power_level = 2 if super else 1
		body.powerup_jump()
		queue_free()
		
		# Advance story - collect jump shoes
		if body.story < 4:
			body.story = 4
