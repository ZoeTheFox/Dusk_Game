extends Node3D

@onready
var animation_player = $AnimationPlayer

var ship_scale : bool

var prompt_showing : bool

func show_prompt():
	if (prompt_showing):
		return
	
	if (ship_scale):
		animation_player.play("show_prompt_ship_scale")
	else:
		animation_player.play("show_prompt")
	prompt_showing = true

func hide_prompt():
	if (ship_scale):
		animation_player.play("hide_prompt_ship_scale")
	else:
		animation_player.play("hide_prompt")
	
	prompt_showing = false
