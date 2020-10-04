extends Control

func _on_ReturnButton_pressed() -> void:
	set_highlight($Menu/ReturnButton, true)
	var _ignored = get_tree().change_scene("res://TitleScreen/TitleScreen.tscn")


func _on_ReturnButton_mouse_entered() -> void:
	set_highlight($Menu/ReturnButton, true)
	$Menu/ReturnButton/SelectSound.play()


func _on_ReturnButton_mouse_exited() -> void:
	set_highlight($Menu/ReturnButton, false)


func set_highlight(button, on_or_off):
	if on_or_off:
		button.modulate = Color("#ef7d57")
	else:
		button.modulate = Color(1, 1, 1, 1)
	
