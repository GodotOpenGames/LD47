extends Sprite

# dumb hack to get the end game text
export var last_sign = false

var lines = [
	"HEY, FRIEND! ARE YOU STUCK HERE TOO?\nPRESS UP TO SEE MY COOL TIPS\nOR FASHION ADVICE",
	"HEY! BACK SO SOON?\nSEE THESE DOORS? PRESS UP TO ENTER\nBUT THERE'S NOTHING THERE",
	"HEY, BUDDY!\nPRESS X TO PICKUP BLOCKS\nBUT I LIKE TO LEAVE THEM HERE",
	"DID YOU SEE MY COOL SHOES?\nA SIGN HAS NO FEET BUT THAT'S OK\nIT'S NOT LIKE THEY MAKE YOU JUMP HIGHER,\nSILLY",
	"DID YOU SEE THAT LOCKED DOOR?\nFORGET YOU SAW THAT LOCKED DOOR\nI LOST THE KEY ANYWAY",
	"ISN'T IT NICE HERE?\nI LIKE IT HERE, EXCEPT THE TOP PART\nTHE TOP IS BAD DON'T GO THERE",
	"WAIT, IS THAT MY BLOCK?\nPRESS X TO PUT IT DOWN AND\nI'LL FORGIVE YOU",
	"IS THAT A KEY?\nI DON'T REMEMBER SEEING A LOCKED DOOR\nJUST THROW IT AWAY",
	"HEY, FRIEND! WHERE ARE YOU GOING?\nTHAT DOOR SUCKS, IT'S BETTER IN HERE\nIT-IT'S NOT LIKE I WANTED TO HANG OUT\nWITH YOU ANYWAY",
]

func _ready() -> void:
	set_process_input(false)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") || \
		event.is_action_pressed("pickup") || \
		event.is_action_pressed("ui_accept") || \
		event.is_action_pressed("ui_cancel"):
		close_text_box()

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		# Only auto-read the first line
		if body.story == 0:
			open_text_box(0)
			body.story = 1
		
		# Notify player the sign can be read
		body.sign_object = self

func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == "Player":
		body.sign_object = null
	
func open_text_box(index):
	if last_sign:
		index = lines.size() - 1
		
	# Set sign text
	$CanvasLayer/PopupDialog/ColorRect/Label.text = lines[index]
	
	# Show modal dialogue box
	get_tree().paused = true
	$CanvasLayer/PopupDialog.popup()
	$CanvasLayer/PopupDialog/AnimationPlayer.play("show_text")
	$TextSound.play()

func close_text_box():
	get_tree().paused = false
	$CanvasLayer/PopupDialog/Triangle.visible = false
	$CanvasLayer/PopupDialog.hide()
	
func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	$TextSound.stop()
	$CanvasLayer/PopupDialog/Triangle.visible = true
	set_process_input(true)
