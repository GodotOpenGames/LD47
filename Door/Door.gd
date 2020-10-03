extends Area2D

export var destination = 0
export var locked = false

func _ready() -> void:
	if locked:
		# Adjust the sprite to use the locked door image
		# Assumes the spritesheet layout hasn't changed
		$Sprite.region_rect.position.x += 32

func unlock():
	if locked:
		locked = false
		$Sprite.region_rect.position.x -= 32

func _on_Door1_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.door = self


func _on_Door1_body_exited(body: Node) -> void:
	if body.name == "Player":
		body.door = null
