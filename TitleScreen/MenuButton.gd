extends Button

export (String) var next_scene_path = null

func _on_MenuButton_pressed() -> void:
	modulate = Color(1, 0, 0, 1)
	$PressSound.play()
	if next_scene_path != null:
		var _ignore = get_tree().change_scene(next_scene_path)


func _on_MenuButton_mouse_entered() -> void:
	modulate = Color("#ffcd75")
	$SelectSound.play()


func _on_MenuButton_mouse_exited() -> void:
	modulate = Color(1, 1, 1, 1)
