extends Control


func set_highlight(button, on_or_off):
	if on_or_off:
		button.modulate = Color("#ef7d57")
	else:
		button.modulate = Color(1, 1, 1, 1)


func _on_Fade_fade_complete() -> void:
	var _ignored = get_tree().change_scene("res://World/World.tscn")


func _on_StartButton_pressed() -> void:
	set_highlight($Menu/Buttons/StartButton, true)
	$Fade.fade_to_black()
	$StartGameSound.play()


func _on_StartButton_mouse_entered() -> void:
	set_highlight($Menu/Buttons/StartButton, true)
	$Menu/Buttons/StartButton/SelectSound.play()


func _on_StartButton_mouse_exited() -> void:
	set_highlight($Menu/Buttons/StartButton, false)
