extends Node2D

var room_scenes = [
	preload("res://Rooms/Room1.tscn"),
	preload("res://Rooms/Room2.tscn"),
	preload("res://Rooms/Room3.tscn")
]

var current_room = null

func _ready() -> void:
	change_room(0)

func change_room(index):
	# Check if the game should end
	if index >= room_scenes.size():
		game_over()
		return

	if current_room != null:
		current_room.queue_free()
		
	# Otherwise, load the next room
	current_room = room_scenes[index].instance()
	add_child(current_room)
	$Player.position = current_room.get_node("PlayerStartPosition").position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		# Just start over if you get stuck
		$Player.reset_stats()
		change_room(0)
#	if event.is_action_pressed("ui_accept"):
#		print("screenshot!")
#		var image = get_viewport().get_texture().get_data()
#		image.flip_y()
#		image.save_png("screenshot0.png")

func game_over():
	# Had to put Fade inside a CanvasLayer to make it visible above the room node
	$CanvasLayer/Fade/AnimationPlayer.play("fade_to_black")

func _on_Fade_fade_complete() -> void:
	var _ignore = get_tree().change_scene("res://WinScreen/WinScreen.tscn")
