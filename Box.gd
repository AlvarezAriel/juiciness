extends KinematicBody2D

const group = 'box'
var GRAVITY = 20
const UP_DIRECTION = Vector2(0, -1)

var velocity = Vector2(0, 0)

func _physics_process(delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, UP_DIRECTION)
	velocity.x = 0
	
func push_by_player(player):
	velocity.x = player.velocity.x
	
func change_gravity():
	GRAVITY = -20
