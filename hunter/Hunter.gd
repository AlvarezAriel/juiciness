extends KinematicBody2D

export (float) var max_jump_x = 128.0
export (float) var max_jump_y = 128.0
export (int) var run_speed = 100

export (int) var jump_speed = 400
export (int) var gravity = 20


enum {IDLE, RUN, JUMP, FALL, CLIMB, HURT, ROLL, BOW}
const animations = ['idle', 'run', 'jump', 'fall', 'climb', 'hit', 'roll', 'bow']

const UP_DIRECTION = Vector2(0,-1)
signal magic_jump_signal

var velocity = Vector2()
var state
var new_anim
var anim

func _ready():
	change_state(IDLE)


func change_state(new_state):
	
	if (state == BOW and $AnimatedSprite.is_playing()):
		pass
	else:	
		state = new_state
		new_anim = animations[state]
	
func cast_box():
	if not $PushRay.is_colliding():
		var scene = load("res://Box.tscn")
		var box = scene.instance()
		box.position = Vector2(position + $PushRay.cast_to * 2.5)
		box.position.x -= 6
		get_parent().add_child(box)
		
func reset_camera_zoom():
	$Tween.interpolate_property($Camera2D, 
			'zoom', 
			$Camera2D.zoom, 
			Vector2(0.4, 0.4),
			0.5,
			Tween.TRANS_CUBIC,
			Tween.EASE_IN
			)
	$Tween.start()	
		
		
func get_input():
	velocity.x = 0
	
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_up')
	var box =  Input.is_action_just_pressed('ui_select')
	
	if box:
		#cast_box()
		emit_signal('magic_jump_signal')

	if !right and !left and (state == RUN or state == FALL):
		change_state(IDLE)
		
	if jump and is_on_floor():
		change_state(JUMP)
		print($AnimatedSprite.is_playing())
		velocity.y = -get_jump_speed()
	elif not is_on_floor() && velocity.y > 0:
		change_state(FALL)
	elif is_on_floor() and (right or left):
		change_state(RUN)		
			
	if right:
		velocity.x = run_speed
	elif left:
		velocity.x = -run_speed

func get_gravity():
	return (2 * max_jump_y * (run_speed^2)) / pow((max_jump_x/2),2)

func get_jump_speed():
	return (2 * max_jump_y * run_speed) / (max_jump_x/2)

func some_signal_callback():
	print('wololo!')
	
func _process(delta):
	
	get_input()
	
	if new_anim != anim:
		anim = new_anim
		$AnimatedSprite.play(anim)
		

func _physics_process(delta):

	velocity.y += get_gravity()
	
	if (velocity.x != 0):
		$AnimatedSprite.flip_h = velocity.x < 0
		$PushRay.cast_to.x = sign(velocity.x) * abs($PushRay.cast_to.x)
		
	if $PushRay.is_colliding():
		var collider = $PushRay.get_collider()
		if collider.group and collider.group == 'box':
			collider.push_by_player(self)

	velocity = move_and_slide(velocity, UP_DIRECTION)

	if position.y > 600:
		get_tree().reload_current_scene()
		
	var cameraDistance = ($Camera2D.get_camera_screen_center() - position).length()	
	
	if velocity.y > run_speed * 5:
		$Camera2D.zoom += Vector2(0.02, 0.02)	
	elif $Camera2D.zoom.x > 0.4:
		$Camera2D.zoom -= Vector2(0.01, 0.01)
				

