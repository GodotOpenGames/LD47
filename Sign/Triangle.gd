extends Node2D

func _draw():
	var points = PoolVector2Array([Vector2(740, 180), Vector2(760, 180), Vector2(750, 200)])
	draw_colored_polygon(points, Color("#f4f4f4"))
