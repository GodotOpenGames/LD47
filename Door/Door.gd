extends Node2D

export var height = 1
export var closed = false
export var locked = false

func _ready() -> void:
	if closed:
		$Sprite.region_rect.position.x += 32
		
	# Make door taller by adding more sprites
	for i in range(1, height):
		var bottom_sprite = $Sprite.duplicate()
		bottom_sprite.position.y += i * 32
		bottom_sprite.region_rect.position.y += 32
		if locked && i == height-1:
			bottom_sprite.region_rect.position.x += 32
		add_child(bottom_sprite)
