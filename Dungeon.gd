extends Node2D

func _ready():
	$Hunter.connect("magic_jump_signal", $Box , "change_gravity")
