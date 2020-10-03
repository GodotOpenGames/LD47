extends StaticBody2D

func _process(delta: float) -> void:
	print("collider: " + str($RayCastLeft.get_collider()))
