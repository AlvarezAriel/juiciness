extends KinematicBody2D

func _fixed_process(delta):

  if is_colliding():            
    print(get_collider())
    pass
	
func _ready():
    connect("body_enter", self, "_on_enemy_body_enter")


func _on_enemy_body_enter(body):
	print("Collision")
	if (body.get_name() == "Player"):
		print("Ouch!")	