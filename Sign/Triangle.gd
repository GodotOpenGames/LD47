extends Node2D

func _draw():
	var points = PoolVector2Array([Vector2(750, 180), Vector2(770, 180), Vector2(760, 200)])
	draw_colored_polygon(points, Color("#f4f4f4"))
