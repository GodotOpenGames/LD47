extends Sprite

var lines = [
	"HEY! DON'T JUST RUN PAST!\nYOU HAVE TO PRESS UP IF\nYOU WANT TO READ MY SIGN",
	"HEY! BACK AGAIN SO SOON?\nTHESE ARE MY DOORS,\nONLY COOL PEOPLE ARE ALLOWED TO\nPUSH UP TO GO THROUGH THEM",
	"HEY!\nI PUT MY BLOCKS RIGHT WHERE I LIKE THEM!\nDON'T PRESS X TO PICK UP AND\nCARRY AROUND MY BLOCKS",
	"DID YOU SEE MY JUMP SHOES?\nAS A SIGN, I DON'T HAVE FEET BUT I CAN\nSTILL MAKE A FASHION STATEMENT",
	"DID YOU SEE THAT LOCKED DOOR?\nFORGET YOU SAW THAT LOCKED DOOR\nI LOST THE KEY ANYWAY",
	"THIS IS JUST OLD BLOCK STORAGE\nTHERE IS NOTHING GOOD HERE\nNOT EVEN AT THE TOP",
	"WAIT, WHERE DID YOU GET THAT?\nPRESS X TO PUT IT DOWN AND\nI'LL FORGIVE YOU",
	"IS THAT A KEY?\nI DON'T REMEMBER A LOCKED DOOR HERE\nJUST THROW IT AWAY"
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
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	$TextSound.stop()
	$CanvasLayer/PopupDialog/Triangle.visible = true
	set_process_input(true)
