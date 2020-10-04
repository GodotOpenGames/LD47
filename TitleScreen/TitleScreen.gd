extends Control


func _on_StartGameButton_pressed() -> void:
	set_highlight($Menu/Buttons/StartGameButton, true)
	$Fade.fade_to_black()
	$StartGameSound.play()


func _on_HowToButton_pressed() -> void:
	set_highlight($Menu/Buttons/HowToButton, true)
	var _ignored = get_tree().change_scene("res://HowToScreen/HowToScreen.tscn")


func _on_StartGameButton_mouse_entered() -> void:
	set_highlight($Menu/Buttons/StartGameButton, true)
	$Menu/Buttons/StartGameButton/SelectSound.play()


func _on_StartGameButton_mouse_exited() -> void:
	set_highlight($Menu/Buttons/StartGameButton, false)


func _on_HowToButton_mouse_entered() -> void:
	set_highlight($Menu/Buttons/HowToButton, true)
	$Menu/Buttons/HowToButton/SelectSound.play()


func _on_HowToButton_mouse_exited() -> void:
	set_highlight($Menu/Buttons/HowToButton, false)


func set_highlight(button, on_or_off):
	if on_or_off:
		button.modulate = Color("#ef7d57")
	else:
		button.modulate = Color(1, 1, 1, 1)
	


func _on_Fade_fade_complete() -> void:
	var _ignored = get_tree().change_scene("res://World/World.tscn")
