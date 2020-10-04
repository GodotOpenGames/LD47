extends Area2D

export var super = false
var hue = 0

func _ready() -> void:
	$SparkleSprite.visible = super
	
func _process(delta: float) -> void:
	# Only the super shoes sparkle
	if super:
		hue += delta
		var color = Color.from_hsv(hue, 1, 1, 1)
		$SparkleSprite.modulate = color
		
func _on_Powerup_body_entered(body: Node) -> void:
	if body.name == "Player":
		var power_level = 2 if super else 1
		print("power level: " + str(power_level))
		body.powerup_jump()
		queue_free()
