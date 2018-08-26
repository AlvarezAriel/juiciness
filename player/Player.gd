extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = 400
export (int) var gravity = 20

enum {IDLE, RUN, JUMP, FALL, CLIMB, HURT, CROUCH}
const animations = ['idle', 'run', 'jump_up', 'jump_down', 'climb', 'hurt', 'crouch']

const UP_DIRECTION = Vector2(0,-1)

var velocity = Vector2()
var state
var new_anim
var anim

func _ready():
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	new_anim = animations[state]
	

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')

	if !right and !left and state != JUMP:
		change_state(IDLE)
		
	if jump and is_on_floor():
		change_state(JUMP)
		velocity.y = -jump_speed
	elif not is_on_floor() && velocity.y > 0:
		change_state(FALL)
	elif is_on_floor() and (right or left):
		change_state(RUN)		
			
	if right:
		velocity.x = run_speed
	elif left:
		velocity.x = -run_speed
		

		
	if (velocity.x != 0):
		$Sprite.flip_h = velocity.x < 0


func _process(delta):
	
	get_input()
	
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)


func _physics_process(delta):
	
	velocity.y += gravity
			
	velocity = move_and_slide(velocity, UP_DIRECTION)

	if position.y > 600:
		get_tree().reload_current_scene()	