extends Node2D

var room_scenes = [
	preload("res://Rooms/Room1.tscn"),
	preload("res://Rooms/Room2.tscn")
]

var current_room = null

func _ready() -> void:
	current_room = room_scenes[0].instance()
	add_child(current_room)
	$Player.position = current_room.get_node("PlayerStartPosition").position

func change_room(index):
	current_room.queue_free()
	current_room = room_scenes[index].instance()
	add_child(current_room)
	$Player.position = current_room.get_node("PlayerStartPosition").position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		# Just start over if you get stuck
		$Player.reset_stats()
		change_room(0)
