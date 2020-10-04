extends ColorRect

signal fade_complete

func fade_to_black():
	$AnimationPlayer.play("fade_to_black")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	emit_signal("fade_complete")
