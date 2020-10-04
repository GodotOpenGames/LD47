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
	if current_room != null:
		current_room.queue_free()
		
	# Check if the game should end
	if index >= room_scenes.size():
		game_over()
		return

	# Otherwise, load the next room
	current_room = room_scenes[index].instance()
	add_child(current_room)
	$Player.position = current_room.get_node("PlayerStartPosition").position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		# Just start over if you get stuck
		$Player.reset_stats()
		change_room(0)

func game_over():
	var _ignore = get_tree().change_scene("res://WinScreen/WinScreen.tscn")
